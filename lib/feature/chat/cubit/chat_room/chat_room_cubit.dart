import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  ChatRoomCubit()
      : super(
          ChatRoomState(),
        );

  void cleanMessageController() => emit(state.copyWith(message: ''));

  void updateMessage(String val) => emit(state.copyWith(message: val));

  void turnOffFirstTime() => emit(state.copyWith(firstTime: false));
}
