part of 'home_bloc.dart';

@immutable
class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Status nextPageStatus;
  final Failure? nextPageFailure;
  final PaginationApiResponse<Room> rooms;
  final List<Category>? categories;
  final List<WebsocketModel>? websocketModels;
  final User authenticatedUser;

  HomeLoaded({
    required this.rooms,
    this.categories,
    this.websocketModels,
    this.nextPageFailure,
    this.nextPageStatus = Status.initial,
    required this.authenticatedUser,
  }) : assert(rooms.data.isEmpty || websocketModels!.isNotEmpty,
            'Websocket models cannot be empty if rooms are not empty');

  HomeLoaded copyWith({
    PaginationApiResponse<Room>? rooms,
    List<Category>? categories,
    List<WebsocketModel>? websocketModels,
    User? authenticatedUser,
    Status? nextPageStatus,
    Failure? nextPageFailure,
  }) {
    return HomeLoaded(
      rooms: rooms ?? this.rooms,
      websocketModels: websocketModels ?? this.websocketModels,
      categories: categories ?? this.categories,
      authenticatedUser: authenticatedUser ?? this.authenticatedUser,
      nextPageStatus: nextPageStatus ?? this.nextPageStatus,
      nextPageFailure: nextPageFailure ?? this.nextPageFailure,
    );
  }

  @override
  List<Object?> get props => [
        rooms,
        categories,
        authenticatedUser,
        websocketModels,
        nextPageFailure,
        nextPageStatus,
      ];
}

class HomeError extends HomeState {
  final Failure failure;

  HomeError(this.failure);
}
