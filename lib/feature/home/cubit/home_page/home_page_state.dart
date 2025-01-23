part of 'home_page_cubit.dart';

class HomePageState extends Equatable {
  final List<Room> dummyRooms;

  HomePageState({
    List<Room>? rooms,
  }) : dummyRooms = rooms ?? [];

  HomePageState copyWith({
    List<Room>? rooms,
  }) {
    return HomePageState(
      rooms: rooms ?? this.dummyRooms,
    );
  }

  @override
  List<Object> get props => [
        dummyRooms,
      ];
}
