import 'package:bloc/bloc.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  ChatRoomCubit()
      : super(
          ChatRoomState(
            chatsParam: [
              // Chat(
              //   id: 1,
              //   sentBy: 'Goofy',
              //   content: 'Hello, how are you?',
              //   type: ChatType.text,
              //   createdAt: DateTime.now(),
              //   updatedAt: DateTime.now().subtract(const Duration(days: 2)),
              // ),
              // Chat(
              //   id: 2,
              //   sentBy: 'Mickey',
              //   content: 'I am fine, thank you!',
              //   type: ChatType.text,
              //   createdAt: DateTime.now(),
              //   updatedAt: DateTime.now().subtract(const Duration(days: 2)),
              // ),
              // Chat(
              //   id: 3,
              //   sentBy: 'Goofy',
              //   content: 'What are you doing?',
              //   type: ChatType.text,
              //   createdAt: DateTime.now(),
              //   updatedAt: DateTime.now().subtract(const Duration(days: 1)),
              // ),
              // Chat(
              //   id: 4,
              //   sentBy: 'Mickey',
              //   content: 'I am working on a project.',
              //   type: ChatType.text,
              //   createdAt: DateTime.now(),
              //   updatedAt: DateTime.now(),
              // ),
            ] /* .reversed.toList() */,
          ),
        );

  void updateMessage(String val) => emit(state.copyWith(message: val));
}
