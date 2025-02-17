part of 'choose_category_bloc.dart';

sealed class ChooseCategoryState extends Equatable {
  const ChooseCategoryState();

  @override
  List<Object?> get props => [];
}

/// CC = ChooseCategory
final class CCInitial extends ChooseCategoryState {}

final class CCInitialLoading extends ChooseCategoryState {}

final class CCInitialLoaded extends ChooseCategoryState {
  final Status updateStatus;
  final Failure? updateFailure;
  final List<Category> categories;

  const CCInitialLoaded({
    this.updateStatus = Status.initial,
    this.updateFailure,
    this.categories = const [],
  });

  // copyiwth
  CCInitialLoaded copyWith({
    Status? updateStatus,
    Failure? updateFailure,
    List<Category>? categories,
  }) {
    return CCInitialLoaded(
      updateStatus: updateStatus ?? this.updateStatus,
      updateFailure: updateFailure ?? this.updateFailure,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        updateStatus,
        updateFailure,
        categories,
      ];
}

final class CCInitialError extends ChooseCategoryState {
  final Failure? failure;

  const CCInitialError({
    this.failure,
  });

  @override
  List<Object?> get props => [failure];
}
