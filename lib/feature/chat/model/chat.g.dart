// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: (json['id'] as num).toInt(),
      sentBy: json['sent_by'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$ChatTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'sent_by': instance.sentBy,
      'content': instance.content,
      'type': _$ChatTypeEnumMap[instance.type]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ChatTypeEnumMap = {
  ChatType.text: 'text',
  ChatType.image: 'img',
};
