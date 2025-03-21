// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
      id: (json['id'] as num).toInt(),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      role: $enumDecode(_$ParticipantRoleEnumMap, json['role']),
      lastViewed: DateTime.parse(json['last_viewed'] as String),
    );

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'role': _$ParticipantRoleEnumMap[instance.role]!,
      'last_viewed': instance.lastViewed.toIso8601String(),
    };

const _$ParticipantRoleEnumMap = {
  ParticipantRole.admin: 'admin',
  ParticipantRole.member: 'member',
};
