import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageState());

  toggleSelectedCategory(int categoryId) {
    if (state.selectedCategory == categoryId) {
      emit(state.copyWith(selectedCategory: 0));
    } else {
      emit(state.copyWith(selectedCategory: categoryId));
    }
  }
}
