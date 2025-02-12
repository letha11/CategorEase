part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  /// Loading state when fetching next page on pagination.
  final NextPageStatus nextPageStatus;
  final Failure? nextPageFailure;
  final PaginationApiResponse<User> users;

  SearchLoaded({
    required this.users,
    this.nextPageStatus = NextPageStatus.initial,
    this.nextPageFailure,
  });

  SearchLoaded copyWith({
    NextPageStatus? nextPageStatus,
    Failure? nextPageFailure,
    PaginationApiResponse<User>? users,
  }) {
    return SearchLoaded(
      users: users ?? this.users,
      nextPageStatus: nextPageStatus ?? this.nextPageStatus,
      nextPageFailure: nextPageFailure ?? this.nextPageFailure,
    );
  }

  @override
  List<Object?> get props => [
        nextPageStatus,
        nextPageFailure,
        users,
      ];
}

class SearchError extends SearchState {
  final Failure failure;

  SearchError(this.failure);

  @override
  List<Object?> get props => [failure];
}
