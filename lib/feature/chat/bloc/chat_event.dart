part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class FetchChat extends ChatEvent {
  final int roomId;

  FetchChat({required this.roomId});
}

class FetchChatNextPage extends ChatEvent {}
