import 'package:bloc/bloc.dart';
import 'package:categorease/feature/category/model/category.dart';

part 'choose_category_state.dart';

class ChooseCategoryCubit extends Cubit<ChooseCategoryState> {
  ChooseCategoryCubit()
      : super(
          ChooseCategoryState(
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
    final List<Category> selectedCategories = state.selectedCategories;
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
