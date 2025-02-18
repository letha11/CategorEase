part of 'create_room_bloc.dart';

sealed class CreateRoomEvent extends Equatable {
  const CreateRoomEvent();

  @override
  List<Object> get props => [];
}

class CreateRoomRequested extends CreateRoomEvent {
  final String roomName;
  final int userId;

  const CreateRoomRequested({
    required this.roomName,
    required this.userId,
  });

  @override
  List<Object> get props => [
        roomName,
        userId,
      ];
}
