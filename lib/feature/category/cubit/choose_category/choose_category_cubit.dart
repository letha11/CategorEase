import 'package:bloc/bloc.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:equatable/equatable.dart';

part 'choose_category_state.dart';

class ChooseCategoryCubit extends Cubit<ChooseCategoryState> {
  ChooseCategoryCubit()
      : super(
          const ChooseCategoryState(
            categories: [
              Category(id: 1, name: 'Work', hexColor: '347BD5'),
              Category(id: 2, name: 'Friends', hexColor: '6548BC'),
              Category(id: 3, name: 'College', hexColor: '971FA0'),
              Category(id: 4, name: 'Family', hexColor: '479948'),
            ],
            selectedCategories: [
              Category(id: 1, name: 'Work', hexColor: '347BD5'),
            ],
          ),
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
