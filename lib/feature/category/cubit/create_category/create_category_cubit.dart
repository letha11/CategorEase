import 'package:bloc/bloc.dart';
import 'package:categorease/config/theme/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  CreateCategoryCubit() : super(CreateCategoryState());

  void updatePickedColor(Color color) {
    emit(state.copyWith(pickedColor: color));
  }

  void updatePreviewText(String val) {
    emit(state.copyWith(previewText: val));
  }
}
