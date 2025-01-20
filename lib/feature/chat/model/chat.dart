import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  final int id;
  final String sentBy;
  final String content;
  final ChatType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.sentBy,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

enum ChatType {
  @JsonValue('text')
  text,
  @JsonValue('img')
  image,
}
