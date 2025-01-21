part of 'choose_category_cubit.dart';

final class ChooseCategoryState extends Equatable {
  final List<Category> categories;
  final List<Category> selectedCategories;

  const ChooseCategoryState({
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

  @override
  List<Object?> get props => [
        categories,
        selectedCategories,
      ];
}
