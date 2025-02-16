// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterBody _$RegisterBodyFromJson(Map<String, dynamic> json) => RegisterBody(
      name: json['name'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      nickName: json['nickName'] as String,
      birth: json['birth'] as String,
      dday: json['dday'] as String,
      isTermsAgreed: json['isTermsAgreed'] as bool,
      isMarketingAgreed: json['isMarketingAgreed'] as bool,
    );

Map<String, dynamic> _$RegisterBodyToJson(RegisterBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'gender': _$GenderEnumMap[instance.gender]!,
      'nickName': instance.nickName,
      'birth': instance.birth,
      'dday': instance.dday,
      'isTermsAgreed': instance.isTermsAgreed,
      'isMarketingAgreed': instance.isMarketingAgreed,
    };

const _$GenderEnumMap = {
  Gender.MALE: 'MALE',
  Gender.FEMALE: 'FEMALE',
  Gender.OTHER: 'OTHER',
};
