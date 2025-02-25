// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String,
      profileImage:
          UserModel._imageUrlWithTimeStamp(json['profileImage'] as String?),
      email: json['email'] as String,
      gender: UserModel._genderFromJson(json['gender'] as String),
      nickName: json['nickName'] as String,
      birth: json['birth'] as String,
      dday: json['dday'] as String?,
      partnerId: (json['partnerId'] as num?)?.toInt(),
      partnerName: json['partnerName'] as String?,
      partnerNickname: json['partnerNickname'] as String?,
      partnerProfileImage: UserModel._imageUrlWithTimeStamp(
          json['partnerProfileImage'] as String?),
      isTermsAgreed: json['isTermsAgreed'] as bool,
      isMarketingAgreed: json['isMarketingAgreed'] as bool,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'profileImage': instance.profileImage,
      'email': instance.email,
      'gender': UserModel._genderToJson(instance.gender),
      'nickName': instance.nickName,
      'birth': instance.birth,
      'dday': instance.dday,
      'partnerId': instance.partnerId,
      'partnerName': instance.partnerName,
      'partnerNickname': instance.partnerNickname,
      'partnerProfileImage': instance.partnerProfileImage,
      'isTermsAgreed': instance.isTermsAgreed,
      'isMarketingAgreed': instance.isMarketingAgreed,
    };
