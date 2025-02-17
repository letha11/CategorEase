import 'package:bloc/bloc.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:equatable/equatable.dart';

part 'choose_category_state.dart';

class ChooseCategoryCubit extends Cubit<ChooseCategoryCubitState> {
  ChooseCategoryCubit()
      : super(
          const ChooseCategoryCubitState(selectedCategories: []),
        );

  void toggleCategory(Category category) {
    /// Important, since this makes the list doesn't point into the same memory address, since we uses Equatable this will make the State update.
    final List<Category> selectedCategories = [...state.selectedCategories];
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    emit(
      state.copyWith(
        selectedCategories: selectedCategories,
      ),
    );
  }
}
