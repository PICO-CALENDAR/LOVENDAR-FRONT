import 'package:json_annotation/json_annotation.dart';

part 'invite_code_model.g.dart';

@JsonSerializable()
class InviteCodeModel {
  final String inviteCode;

  InviteCodeModel({
    required this.inviteCode,
  });

  factory InviteCodeModel.fromJson(Map<String, dynamic> json) =>
      _$InviteCodeModelFromJson(json);

  // toJson 메서드
  Map<String, dynamic> toJson() => _$InviteCodeModelToJson(this);
}
