import 'package:json_annotation/json_annotation.dart';

part 'google_auth_request.g.dart';

@JsonSerializable()
class GoogleAuthBody {
  final String idToken;

  GoogleAuthBody({
    required this.idToken,
  });

  Map<String, dynamic> toJson() => _$GoogleAuthBodyToJson(this);
}
