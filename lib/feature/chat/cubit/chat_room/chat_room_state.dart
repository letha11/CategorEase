part of 'chat_room_cubit.dart';

class ChatRoomState extends Equatable {
  final List<Chat> chats;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final bool firstTime;
  final String message;

  ChatRoomState({
    List<Chat>? chatsParam,
    this.message = '',
    this.firstTime = true,
  }) : chats = chatsParam ?? const [];

  ChatRoomState copyWith({
    List<Chat>? chats,
    String? message,
    bool? firstTime,
  }) {
    return ChatRoomState(
      chatsParam: chats ?? this.chats,
      message: message ?? this.message,
      firstTime: firstTime ?? this.firstTime,
    );
  }

  @override
  List<Object> get props => [chats, message, firstTime];
}
