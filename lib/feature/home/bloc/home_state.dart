part of 'home_bloc.dart';

// class HomeState extends Equatable {
//   final bool isLoading;
//   final List<Room>? rooms;
//   final List<Category>? categories;

//   const HomeState({
//     this.isLoading = true,
//     this.rooms,
//     this.categories,
//   });

//   HomeState copyWith({
//     bool? isLoading,
//     List<Room>? rooms,
//     List<Category>? categories,
//   }) {
//     return HomeState(
//       isLoading: isLoading ?? this.isLoading,
//       rooms: rooms ?? this.rooms,
//       categories: categories ?? this.categories,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         isLoading,
//         rooms,
//         categories,
//       ];
// }

@immutable
class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Room>? rooms;
  final List<Category>? categories;

  HomeLoaded({this.rooms, this.categories});

  HomeLoaded copyWith({
    List<Room>? rooms,
    List<Category>? categories,
  }) {
    return HomeLoaded(
      rooms: rooms ?? this.rooms,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [rooms, categories];
}

class HomeError extends HomeState {
  final Failure failure;

  HomeError(this.failure);
}
