part of 'choose_category_cubit.dart';

final class ChooseCategoryCubitState extends Equatable {
  final List<Category> selectedCategories;

  const ChooseCategoryCubitState({
    required this.selectedCategories,
  });

  ChooseCategoryCubitState copyWith({
    List<Category>? selectedCategories,
  }) {
    return ChooseCategoryCubitState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  @override
  List<Object?> get props => [selectedCategories];
}
