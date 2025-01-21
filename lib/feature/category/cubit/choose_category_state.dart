part of 'choose_category_cubit.dart';

final class ChooseCategoryState {
  final List<Category> categories;
  final List<Category> selectedCategories;

  ChooseCategoryState({
    required this.categories,
    required this.selectedCategories,
  });

  ChooseCategoryState copyWith({
    List<Category>? categories,
    List<Category>? selectedCategories,
  }) {
    return ChooseCategoryState(
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }
}
