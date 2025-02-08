import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/feature/home/model/participant.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room extends Equatable {
  final int id;
  final String name;
  final List<Participant> participants;
  final List<Category> categories;
  final Chat? lastChat;
  final int unreadMessageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Room({
    required this.id,
    required this.name,
    required this.participants,
    required this.categories,
    this.lastChat,
    required this.unreadMessageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  Room copyWith({
    int? id,
    String? name,
    List<Participant>? participants,
    List<Category>? categories,
    Chat? lastChat,
    int? unreadMessageCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      participants: participants ?? this.participants,
      categories: categories ?? this.categories,
      lastChat: lastChat ?? this.lastChat,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        participants,
        categories,
        lastChat,
        unreadMessageCount,
        createdAt,
        updatedAt,
      ];
}
