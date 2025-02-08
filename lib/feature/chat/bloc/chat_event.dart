part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class FetchChat extends ChatEvent {
  final int roomId;

  FetchChat({required this.roomId});
}

class FetchChatNextPage extends ChatEvent {}

class AddNewChat extends ChatEvent {
  final Chat chat;

  AddNewChat({required this.chat});
}

class SendChatMessage extends ChatEvent {
  final String message;

  SendChatMessage({required this.message});
}
