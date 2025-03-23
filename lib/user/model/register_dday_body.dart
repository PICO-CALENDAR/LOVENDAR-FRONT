import 'package:json_annotation/json_annotation.dart';

part 'register_dday_body.g.dart';

@JsonSerializable()
class RegisterDdayBody {
  final String dday;

  RegisterDdayBody({
    required this.dday,
  });

  factory RegisterDdayBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterDdayBodyFromJson(json);

  // toJson 메서드
  Map<String, dynamic> toJson() => _$RegisterDdayBodyToJson(this);
}
