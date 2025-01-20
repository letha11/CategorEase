import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/feature/home/model/participant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  final int id;
  final String name;
  final List<Participant> participants;
  // final List<Category> categories;
  final Chat lastChat;
  final int unreadMessageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    required this.id,
    required this.name,
    required this.participants,
    // required this.categories,
    required this.lastChat,
    required this.unreadMessageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
