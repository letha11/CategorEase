part of 'create_room_bloc.dart';

sealed class CreateRoomState extends Equatable {
  const CreateRoomState();

  @override
  List<Object> get props => [];
}

final class CreateRoomInitial extends CreateRoomState {}

final class CreateRoomLoading extends CreateRoomState {}

final class CreateRoomSuccess extends CreateRoomState {}

final class CreateRoomError extends CreateRoomState {
  final Failure failure;

  const CreateRoomError(this.failure);

  @override
  List<Object> get props => [failure];
}
