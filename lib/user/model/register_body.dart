import 'package:json_annotation/json_annotation.dart';
import 'package:lovendar/user/model/user_model.dart';

part 'register_body.g.dart';

@JsonSerializable()
class RegisterBody {
  final String? name;
  @JsonKey(
    fromJson: _genderFromJson,
    toJson: _genderToJson,
  )
  final Gender? gender;
  final String? nickName;
  final String? birth;
  final String? dday;
  final bool? isTermsAgreed;
  final bool? isMarketingAgreed;

  RegisterBody({
    this.name,
    this.gender,
    this.nickName,
    this.birth,
    this.dday,
    this.isTermsAgreed,
    this.isMarketingAgreed,
  });

  factory RegisterBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterBodyFromJson(json);

  // toJson 메서드
  Map<String, dynamic> toJson() => _$RegisterBodyToJson(this);

  // Gender 변환 메서드
  static Gender _genderFromJson(String json) {
    switch (json) {
      case '남성':
        return Gender.MALE;
      case '여성':
        return Gender.FEMALE;
      case '기타':
        return Gender.OTHER;
      default:
        throw ArgumentError('Unknown gender value: $json');
    }
  }

  static String? _genderToJson(Gender? gender) {
    if (gender == null) return null; // ✅ null 처리 추가
    switch (gender) {
      case Gender.MALE:
        return 'MALE';
      case Gender.FEMALE:
        return 'FEMALE';
      case Gender.OTHER:
    }
    return null;
  }
}
