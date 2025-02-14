part of 'chat_room_detail_bloc.dart';

class ChatRoomDetailState extends Equatable {
  final Status status;
  final Failure? failure;
  final Room? room;

  const ChatRoomDetailState({
    this.status = Status.initial,
    this.failure,
    this.room,
  });

  ChatRoomDetailState copyWith({
    Status? status,
    Failure? failure,
    Room? room,
  }) {
    return ChatRoomDetailState(
      status: status ?? this.status,
      failure: failure,
      room: room ?? this.room,
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        room,
      ];
}
