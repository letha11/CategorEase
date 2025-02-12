import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/chat/chat_room.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/feature/chat/repository/chat_repository.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:categorease/utils/constants.dart';
import 'package:categorease/utils/websocket_helper.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final RoomRepository _roomRepository;
  final ChatRoomArgs _args;
  late final StreamSubscription _subscription;
  late final int roomId;

  ChatBloc({
    required ChatRepository chatRepository,
    required RoomRepository roomRepository,
    required ChatRoomArgs args,
  })  : _chatRepository = chatRepository,
        _roomRepository = roomRepository,
        _args = args,
        super(ChatInitial()) {
    _subscription = _args.websocketModel.broadcastStream.listen((data) {
      if (data is! String) return;
      if (state is! ChatInitialLoaded) return;
      final loadedState = state as ChatInitialLoaded;

      Map<String, dynamic> parsedData = jsonDecode(data);
      parsedData
          .addEntries([MapEntry('id', loadedState.chats.data.first.id + 1)]);

      add(AddNewChat(
        chat: Chat.fromJson(parsedData),
      ));
    });

    on<FetchChat>(_onFetchChat);
    on<FetchChatNextPage>(_onFetchChatNextPage);
    on<SendChatMessage>((event, emit) {
      WebsocketHelper.sendMessage(_args.websocketModel, event.message);
    });
    on<AddNewChat>((event, emit) {
      if (state is! ChatInitialLoaded) return;
      final loadedState = state as ChatInitialLoaded;
      emit(loadedState.copyWith(
        chats: loadedState.chats.copyWith(
          data: loadedState.chats.data
            ..insert(
              0,
              event.chat,
            ),
        ),
      ));
    });
  }

  _onFetchChat(FetchChat event, Emitter<ChatState> emit) async {
    emit(ChatInitialLoading());
    late final PaginationApiResponse<Chat> chats;
    late final Room roomDetail;
    roomId = event.roomId;

    final result = await _chatRepository.getAllbyRoom(roomId);

    result.fold(
      (l) => emit(ChatInitialError(l)),
      (r) => chats = r,
    );

    if (state is ChatInitialError) return;

    final roomResult = await _roomRepository.getById(roomId);

    roomResult.fold(
      (l) => emit(ChatInitialError(l)),
      (r) => roomDetail = r.data!,
    );

    if (state is ChatInitialError) return;

    emit(
      ChatInitialLoaded(
        chats: chats,
        roomDetail: roomDetail,
        nextPageStatus: NextPageStatus.initial,
      ),
    );
  }

  _onFetchChatNextPage(FetchChatNextPage event, Emitter<ChatState> emit) async {
    if (state is! ChatInitialLoaded) {
      return;
    }
    final ChatInitialLoaded castedState = state as ChatInitialLoaded;

    // Means that there is no next page left (we are at the end of the page)
    if (castedState.chats.next == null) {
      return;
    }

    final int nextPage = castedState.chats.next!;

    emit(
      castedState.copyWith(
        nextPageStatus: NextPageStatus.loading,
      ),
    );

    final result = await _chatRepository.getAllbyRoom(roomId, page: nextPage);

    result.fold(
      (l) => emit(
        castedState.copyWith(
          nextPageStatus: NextPageStatus.error,
          nextPageFailure: l,
        ),
      ),
      (r) => emit(
        castedState.copyWith(
          nextPageStatus: NextPageStatus.loaded,
          chats: r.copyWith(
            data: castedState.chats.data + r.data,
          ),
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
