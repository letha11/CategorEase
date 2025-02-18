import 'package:categorease/feature/home/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant.g.dart';

@JsonSerializable()
class Participant {
  final int id;
  final User user;
  final ParticipantRole role;
  final DateTime lastViewed;

  Participant({
    required this.id,
    required this.user,
    required this.role,
    required this.lastViewed,
  });

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}

enum ParticipantRole {
  @JsonValue('admin')
  admin,
  @JsonValue('member')
  member,
}
