import 'package:json_annotation/json_annotation.dart';

part 'google_auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final int id;
  final String name;
  final String accessToken;
  final String refreshToken;
  final bool isRegistered;

  AuthResponse({
    required this.id,
    required this.name,
    required this.accessToken,
    required this.refreshToken,
    required this.isRegistered,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
