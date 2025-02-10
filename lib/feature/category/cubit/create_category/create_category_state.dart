part of 'create_category_cubit.dart';

class CreateCategoryState extends Equatable {
  final Color pickedColor;
  final String previewText;
  final List<int> selectedRooms;

  CreateCategoryState({
    this.pickedColor = AppTheme.activeColor,
    this.previewText = '',
    List<int>? selectedRooms,
  }) : selectedRooms = selectedRooms ?? [];

  CreateCategoryState copyWith({
    Color? pickedColor,
    String? previewText,
    List<int>? selectedRooms,
  }) {
    return CreateCategoryState(
      pickedColor: pickedColor ?? this.pickedColor,
      previewText: previewText ?? this.previewText,
      selectedRooms: selectedRooms ?? this.selectedRooms,
    );
  }

  @override
  List<Object?> get props => [pickedColor, previewText, selectedRooms];
}
