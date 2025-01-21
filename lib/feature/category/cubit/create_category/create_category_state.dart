part of 'create_category_cubit.dart';

class CreateCategoryState extends Equatable {
  final Color pickedColor;
  final TextEditingController nameController;
  final String previewText;

  CreateCategoryState({
    this.pickedColor = AppTheme.activeColor,
    TextEditingController? nameController,
    this.previewText = '',
  }) : nameController = nameController ?? TextEditingController();

  CreateCategoryState copyWith({
    Color? pickedColor,
    TextEditingController? nameController,
    String? previewText,
  }) {
    return CreateCategoryState(
      pickedColor: pickedColor ?? this.pickedColor,
      nameController: nameController ?? this.nameController,
      previewText: previewText ?? this.previewText,
    );
  }

  @override
  List<Object?> get props => [
        pickedColor,
        nameController,
        previewText,
      ];
}
