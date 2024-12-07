import 'package:json_annotation/json_annotation.dart';

part 'google_auth_response.g.dart';

@JsonSerializable()
class GoogleAuthResponse {
  final int id;
  final String name;
  final String accessToken;
  final String refreshToken;
  final bool isRegistered;

  GoogleAuthResponse({
    required this.id,
    required this.name,
    required this.accessToken,
    required this.refreshToken,
    required this.isRegistered,
  });

  factory GoogleAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthResponseFromJson(json);
}
