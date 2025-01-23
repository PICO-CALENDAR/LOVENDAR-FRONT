import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum Gender {
  MALE,
  FEMALE,
  OTHER,
}

abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String name;
  final String? profileImage;
  final String email;
  @JsonKey(
    fromJson: _genderFromJson,
    toJson: _genderToJson,
  )
  final Gender gender;
  final String nickName;
  final String birth;
  final int? partnerId;
  final String? partnerName;
  final String? partnerNickname;
  final String? partnerProfileImage;
  final bool isTermsAgreed;
  final bool isMarketingAgreed;

  UserModel({
    required this.name,
    required this.profileImage,
    required this.email,
    required this.gender,
    required this.nickName,
    required this.birth,
    this.partnerId,
    this.partnerName,
    this.partnerNickname,
    this.partnerProfileImage,
    required this.isTermsAgreed,
    required this.isMarketingAgreed,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

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

  static String _genderToJson(Gender gender) {
    switch (gender) {
      case Gender.MALE:
        return 'MALE';
      case Gender.FEMALE:
        return 'FEMALE';
      case Gender.OTHER:
        return 'OTHER';
    }
  }
}
