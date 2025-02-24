// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterBody _$RegisterBodyFromJson(Map<String, dynamic> json) => RegisterBody(
      name: json['name'] as String?,
      gender: RegisterBody._genderFromJson(json['gender'] as String),
      nickName: json['nickName'] as String?,
      birth: json['birth'] as String?,
      dday: json['dday'] as String?,
      isTermsAgreed: json['isTermsAgreed'] as bool?,
      isMarketingAgreed: json['isMarketingAgreed'] as bool?,
    );

Map<String, dynamic> _$RegisterBodyToJson(RegisterBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'gender': RegisterBody._genderToJson(instance.gender),
      'nickName': instance.nickName,
      'birth': instance.birth,
      'dday': instance.dday,
      'isTermsAgreed': instance.isTermsAgreed,
      'isMarketingAgreed': instance.isMarketingAgreed,
    };
