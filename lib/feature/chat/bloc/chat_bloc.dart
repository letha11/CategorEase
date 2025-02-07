import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/feature/chat/repository/chat_repository.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  late final int roomId;

  ChatBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatInitial()) {
    on<FetchChat>(_onFetchChat);
    on<FetchChatNextPage>(_onFetchChatNextPage);
  }

  _onFetchChat(FetchChat event, Emitter<ChatState> emit) async {
    emit(ChatInitialLoading());
    roomId = event.roomId;

    final result = await _chatRepository.getAllbyRoom(roomId);

    result.fold(
      (l) => emit(ChatInitialError(l)),
      (r) => emit(
        ChatInitialLoaded(
          chats: r.copyWith(
            data: r.data,
          ),
          nextPageStatus: NextPageStatus.initial,
        ),
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
}
