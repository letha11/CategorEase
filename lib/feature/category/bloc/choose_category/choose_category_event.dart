part of 'choose_category_bloc.dart';

sealed class ChooseCategoryEvent extends Equatable {
  const ChooseCategoryEvent();

  @override
  List<Object> get props => [];
}

class ChooseCategoryFetchCategories extends ChooseCategoryEvent {}

class ChooseCategoryUpdateRoom extends ChooseCategoryEvent {
  final List<Category> selectedCategories;

  const ChooseCategoryUpdateRoom({required this.selectedCategories});
}
