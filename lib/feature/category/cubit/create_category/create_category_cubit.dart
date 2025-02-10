import 'package:bloc/bloc.dart';
import 'package:categorease/config/theme/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  CreateCategoryCubit() : super(CreateCategoryState(selectedRooms: []));

  void updatePickedColor(Color color) {
    emit(state.copyWith(pickedColor: color));
  }

  void updatePreviewText(String val) {
    emit(state.copyWith(previewText: val));
  }

  void toggleSelectedRoom(int roomId) {
    List<int> newSelectedRooms = [...state.selectedRooms];
    if (newSelectedRooms.contains(roomId)) {
      newSelectedRooms.remove(roomId);
    } else {
      newSelectedRooms.add(roomId);
    }

    if (state.selectedRooms.contains(roomId)) {
      emit(state.copyWith(
        selectedRooms: newSelectedRooms,
      ));
    } else {
      emit(state.copyWith(
        selectedRooms: newSelectedRooms,
      ));
    }
  }
}
