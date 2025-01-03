// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_couple_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteCoupleResponse _$DeleteCoupleResponseFromJson(
        Map<String, dynamic> json) =>
    DeleteCoupleResponse(
      couple: (json['couple'] as List<dynamic>)
          .map((e) => CoupleInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeleteCoupleResponseToJson(
        DeleteCoupleResponse instance) =>
    <String, dynamic>{
      'couple': instance.couple,
    };

CoupleInfo _$CoupleInfoFromJson(Map<String, dynamic> json) => CoupleInfo(
      userId: (json['userId'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CoupleInfoToJson(CoupleInfo instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
    };
