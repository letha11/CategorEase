import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat extends Equatable {
  final int id;
  final String sentBy;
  final String content;
  final ChatType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chat({
    required this.id,
    required this.sentBy,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  bool isSender(String username) => username == sentBy;

  @override
  List<Object?> get props => [
        id,
        sentBy,
        content,
        type,
        createdAt,
        updatedAt,
      ];
}

enum ChatType {
  @JsonValue('text')
  text,
  @JsonValue('img')
  image,
}
