import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/room/repository/room_repository.dart';
import 'package:categorease/utils/constants.dart';
import 'package:categorease/utils/extension.dart';
import 'package:equatable/equatable.dart';

part 'chat_room_detail_event.dart';
part 'chat_room_detail_state.dart';

class ChatRoomDetailBloc
    extends Bloc<ChatRoomDetailEvent, ChatRoomDetailState> {
  final RoomRepository _roomRepository;

  ChatRoomDetailBloc(
      {required RoomRepository roomRepository, required Room room})
      : _roomRepository = roomRepository,
        super(ChatRoomDetailState(room: room)) {
    on<ChatRoomDetailRemoveUser>(_onChatRoomDetailRemoveUser);
  }

  void _onChatRoomDetailRemoveUser(
      ChatRoomDetailRemoveUser event, Emitter<ChatRoomDetailState> emit) async {
    if (state.room == null) return;
    emit(state.copyWith(status: Status.loading));

    await Future.delayed(3.seconds);
    final updatedRoom = state.room!.copyWith(
      participants: state.room!.participants
          .where((element) => element.user.id != event.userId)
          .toList(),
    );

    final result = await _roomRepository.update(
      state.room!.id,
      roomName: state.room!.name,
      usersId: updatedRoom.participants.map((e) => e.user.id).toList(),
      categoriesId: state.room!.categories.map((e) => e.id).toList(),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: Status.error, failure: failure));
      },
      (room) {
        emit(state.copyWith(status: Status.loaded, room: updatedRoom));
      },
    );
  }
}
