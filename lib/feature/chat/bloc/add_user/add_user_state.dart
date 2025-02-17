part of 'add_user_bloc.dart';

sealed class AddUserState extends Equatable {
  const AddUserState();

  @override
  List<Object?> get props => [];
}

final class AddUserInitial extends AddUserState {}

class AddUserLoading extends AddUserState {}

class AddUserLoaded extends AddUserState {
  /// Loading state when fetching next page on pagination.
  final Status nextPageStatus;
  final Status updatingStatus;
  final Failure? nextPageFailure;
  final PaginationApiResponse<User> users;
  final Room? updatedRoom;

  const AddUserLoaded({
    required this.users,
    this.updatingStatus = Status.initial,
    this.nextPageStatus = Status.initial,
    this.nextPageFailure,
    this.updatedRoom,
  });

  AddUserLoaded copyWith({
    Status? nextPageStatus,
    Status? updatingStatus,
    Failure? nextPageFailure,
    PaginationApiResponse<User>? users,
    Room? updatedRoom,
  }) {
    return AddUserLoaded(
      users: users ?? this.users,
      updatingStatus: updatingStatus ?? this.updatingStatus,
      nextPageStatus: nextPageStatus ?? this.nextPageStatus,
      nextPageFailure: nextPageFailure ?? this.nextPageFailure,
      updatedRoom: updatedRoom ?? this.updatedRoom,
    );
  }

  @override
  List<Object?> get props => [
        nextPageStatus,
        updatingStatus,
        nextPageFailure,
        users,
        updatedRoom,
      ];
}

class AddUserError extends AddUserState {
  final Failure? failure;
  final Failure? updatingFailure;

  const AddUserError({
    this.failure,
    this.updatingFailure,
  });

  @override
  List<Object?> get props => [failure, updatingFailure];
}
