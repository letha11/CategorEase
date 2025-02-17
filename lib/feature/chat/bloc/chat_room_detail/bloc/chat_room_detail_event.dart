part of 'chat_room_detail_bloc.dart';

sealed class ChatRoomDetailEvent extends Equatable {
  const ChatRoomDetailEvent();

  @override
  List<Object> get props => [];
}

class ChatRoomDetailUpdateRoom extends ChatRoomDetailEvent {
  final Room updatedRoom;

  const ChatRoomDetailUpdateRoom({required this.updatedRoom});
}

class ChatRoomDetailRemoveUser extends ChatRoomDetailEvent {
  final int userId;

  const ChatRoomDetailRemoveUser({required this.userId});
}
