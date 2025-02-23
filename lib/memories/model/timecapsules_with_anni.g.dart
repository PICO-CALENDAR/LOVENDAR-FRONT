// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timecapsules_with_anni.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimecapsulesWithAnni _$TimecapsulesWithAnniFromJson(
        Map<String, dynamic> json) =>
    TimecapsulesWithAnni(
      anniversary: json['anniversary'] as String,
      timeCapsules: (json['timeCapsules'] as List<dynamic>)
          .map((e) => TimecapsuleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimecapsulesWithAnniToJson(
        TimecapsulesWithAnni instance) =>
    <String, dynamic>{
      'anniversary': instance.anniversary,
      'timeCapsules': instance.timeCapsules,
    };
