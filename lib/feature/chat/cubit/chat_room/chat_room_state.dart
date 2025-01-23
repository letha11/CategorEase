part of 'chat_room_cubit.dart';

class ChatRoomState extends Equatable {
  final List<Chat> chats;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final String message;

  ChatRoomState({
    List<Chat>? chatsParam,
    this.message = '',
  }) : chats = chatsParam ?? const [];

  ChatRoomState copyWith({
    List<Chat>? chats,
    String? message,
  }) {
    return ChatRoomState(
      chatsParam: chats ?? this.chats,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        chats,
        message,
      ];
}
