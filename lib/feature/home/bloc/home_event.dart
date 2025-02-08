part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class FetchDataHome extends HomeEvent {}

class UpdateLastChatRoom extends HomeEvent {
  final int roomId;
  final Chat lastChat;

  UpdateLastChatRoom({required this.roomId, required this.lastChat});
}
