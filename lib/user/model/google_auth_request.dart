import 'package:json_annotation/json_annotation.dart';

part 'google_auth_request.g.dart';

@JsonSerializable()
class GoogleAuthRequest {
  final int id;
  final String name;
  final String accessToken;
  final String refreshToken;
  final bool isRegistered;

  GoogleAuthRequest({
    required this.id,
    required this.name,
    required this.accessToken,
    required this.refreshToken,
    required this.isRegistered,
  });

  Map<String, dynamic> toJson() => _$GoogleAuthRequestToJson(this);
}
