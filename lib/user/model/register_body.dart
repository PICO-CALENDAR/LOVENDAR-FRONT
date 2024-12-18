import 'package:json_annotation/json_annotation.dart';
import 'package:pico/user/model/user_model.dart';

part 'register_body.g.dart';

@JsonSerializable()
class RegisterBody {
  final Gender gender;
  final String nickName;
  final String birth;
  final String dday;
  final bool isTermsAgreed;
  final bool isMarketingAgreed;

  RegisterBody({
    required this.gender,
    required this.nickName,
    required this.birth,
    required this.dday,
    required this.isTermsAgreed,
    required this.isMarketingAgreed,
  });

  // toJson 메서드
  Map<String, dynamic> toJson() => _$RegisterBodyToJson(this);
}
