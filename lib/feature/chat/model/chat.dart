import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat extends Equatable {
  late final int id;
  late final String sentBy;
  late final String content;
  late final ChatType type;
  late final DateTime createdAt;
  late final DateTime updatedAt;

  // ignore: prefer_const_constructors_in_immutables
  Chat({
    required this.id,
    required this.sentBy,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  Chat.message({
    required this.content,
  }) {
    id = 0;
    sentBy = '';
    type = ChatType.text;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

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
