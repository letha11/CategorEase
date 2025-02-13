part of 'home_page_cubit.dart';

class HomePageState extends Equatable {
  final int selectedCategory;

  const HomePageState({
    this.selectedCategory = 0,
  });

  HomePageState copyWith({
    int? selectedCategory,
  }) {
    return HomePageState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object> get props => [selectedCategory];
}
