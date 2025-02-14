part of 'chat_room_detail_bloc.dart';

sealed class ChatRoomDetailEvent extends Equatable {
  const ChatRoomDetailEvent();

  @override
  List<Object> get props => [];
}

class ChatRoomDetailRemoveUser extends ChatRoomDetailEvent {
  final int userId;

  const ChatRoomDetailRemoveUser({required this.userId});

  @override
  List<Object> get props => [userId];
}
// class ChatRoomDetailUpdate extends ChatRoomDetailEvent {
//   final Room updatedRoom;

//   ChatRoomDetailUpdate({required this.chatRoom});

//   @override
//   List<Object> get props => [chatRoom];
// }