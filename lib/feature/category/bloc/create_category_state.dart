part of 'create_category_bloc.dart';

@immutable
abstract class CreateCategoryBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateCategoryInitial extends CreateCategoryBlocState {}

class CreateCategoryLoading extends CreateCategoryBlocState {}

class CreateCategorySuccess extends CreateCategoryBlocState {}

class CreateCategoryFailed extends CreateCategoryBlocState {
  final Failure failure;

  CreateCategoryFailed(this.failure);
}
