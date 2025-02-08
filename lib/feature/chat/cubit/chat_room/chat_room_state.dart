part of 'chat_room_cubit.dart';

class ChatRoomState extends Equatable {
  final ScrollController scrollController = ScrollController();
  final bool firstTime;
  final String message;

  ChatRoomState({
    this.message = '',
    this.firstTime = true,
  });

  ChatRoomState copyWith({
    String? message,
    bool? firstTime,
  }) {
    return ChatRoomState(
      message: message ?? this.message,
      firstTime: firstTime ?? this.firstTime,
    );
  }

  @override
  List<Object> get props => [
        message,
        firstTime,
        scrollController,
      ];
}
