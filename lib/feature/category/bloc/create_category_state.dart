part of 'create_category_bloc.dart';

@immutable
class CreateCategoryBlocState extends Equatable {
  final Status roomStatus;
  final Failure? roomFailure;
  final Failure? failure;
  final PaginationApiResponse<Room>? rooms;
  final Status createCategoryStatus;
  final bool isRoomEmpty;

  const CreateCategoryBlocState({
    this.roomStatus = Status.initial,
    this.roomFailure,
    this.failure,
    this.rooms,
    this.createCategoryStatus = Status.initial,
    this.isRoomEmpty = false,
  });

  CreateCategoryBlocState copyWith({
    Status? roomStatus,
    Status? createCategoryStatus,
    Failure? failure,
    Failure? roomFailure,
    PaginationApiResponse<Room>? rooms,
    bool? isRoomEmpty,
  }) {
    return CreateCategoryBlocState(
      roomFailure: roomFailure ?? this.roomFailure,
      roomStatus: roomStatus ?? this.roomStatus,
      createCategoryStatus: createCategoryStatus ?? this.createCategoryStatus,
      failure: failure ?? this.failure,
      rooms: rooms ?? this.rooms,
      isRoomEmpty: isRoomEmpty ?? this.isRoomEmpty,
    );
  }

  @override
  List<Object?> get props => [
        roomStatus,
        roomFailure,
        failure,
        rooms,
        createCategoryStatus,
        isRoomEmpty,
      ];
}

//
// @immutable
// abstract class CreateCategoryBlocState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
//
// class CreateCategoryInitial extends CreateCategoryBlocState {
//   /// In this usecase [nextPageStatus] act as an loading state not only for next page
//   /// but also for initial fetching.
//   final NextPageStatus nextPageStatus;
//
//   /// Same as [nextPageStatus] this also act as catching the failure for initial fetching
//   /// and for next page.
//   final Failure? nextPageFailure;
//   final PaginationApiResponse<Room>? rooms;
//
//   CreateCategoryInitial({
//     this.nextPageStatus = NextPageStatus.initial,
//     this.nextPageFailure,
//     this.rooms,
//   });
//
//   CreateCategoryInitial copyWith({
//     NextPageStatus? nextPageStatus,
//     Failure? nextPageFailure,
//     PaginationApiResponse<Room>? rooms,
//   }) {
//     return CreateCategoryInitial(
//       nextPageStatus: nextPageStatus ?? this.nextPageStatus,
//       nextPageFailure: nextPageFailure ?? this.nextPageFailure,
//       rooms: rooms ?? this.rooms,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//         nextPageStatus,
//         nextPageFailure,
//         rooms,
//       ];
// }
//
// class CreateCategoryLoading extends CreateCategoryBlocState {}
//
// class CreateCategorySuccess extends CreateCategoryBlocState {}
//
// class CreateCategoryFailed extends CreateCategoryBlocState {
//   final Failure failure;
//   final bool roomEmpty;
//
//   CreateCategoryFailed(this.failure, {this.roomEmpty = false});
//
//   @override
//   List<Object?> get props => [failure, roomEmpty];
// }
