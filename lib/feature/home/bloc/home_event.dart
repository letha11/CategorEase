part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class FetchDataHome extends HomeEvent {}

class FetchDataHomeNext extends HomeEvent {}

class FilterHomeByCategory extends HomeEvent {
  final int? categoryId;

  FilterHomeByCategory({this.categoryId});
}

class UpdateLastChatRoom extends HomeEvent {
  final int roomId;
  final Chat lastChat;

  UpdateLastChatRoom({
    required this.roomId,
    required this.lastChat,
  });
}

class UpdateLastViewedRoom extends HomeEvent {
  final int roomId;

  UpdateLastViewedRoom({required this.roomId});
}

class UpdateUpdatedRoom extends HomeEvent {
  final Room updatedRoom;

  UpdateUpdatedRoom({
    required this.updatedRoom,
  });
}
