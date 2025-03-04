part of 'chat_bloc.dart';

@immutable
abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatInitialLoading extends ChatState {}

class ChatInitialLoaded extends ChatState {
  /// Loading state when fetching next page on pagination.
  final Status nextPageStatus;
  final Failure? nextPageFailure;
  final PaginationApiResponse<Chat> chats;
  final Room roomDetail;

  ChatInitialLoaded({
    required this.chats,
    required this.roomDetail,
    this.nextPageStatus = Status.initial,
    this.nextPageFailure,
  });

  ChatInitialLoaded copyWith({
    Status? nextPageStatus,
    Failure? nextPageFailure,
    PaginationApiResponse<Chat>? chats,
    Room? roomDetail,
  }) {
    return ChatInitialLoaded(
      chats: chats ?? this.chats,
      roomDetail: roomDetail ?? this.roomDetail,
      nextPageStatus: nextPageStatus ?? this.nextPageStatus,
      nextPageFailure: nextPageFailure ?? this.nextPageFailure,
    );
  }

  @override
  List<Object?> get props => [
        nextPageStatus,
        nextPageFailure,
        chats,
        roomDetail,
      ];
}

class ChatInitialError extends ChatState {
  final Failure? failure;

  ChatInitialError(this.failure);

  @override
  List<Object?> get props => [failure];
}
