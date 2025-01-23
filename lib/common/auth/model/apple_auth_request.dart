import 'package:json_annotation/json_annotation.dart';

part 'apple_auth_request.g.dart';

@JsonSerializable()
class AppleAuthBody {
  final String idToken;
  final String authorizationCode;

  AppleAuthBody({
    required this.idToken,
    required this.authorizationCode,
  });

  Map<String, dynamic> toJson() => _$AppleAuthBodyToJson(this);
}
