// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timecapsules_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimecapsulesResponse _$TimecapsulesResponseFromJson(
        Map<String, dynamic> json) =>
    TimecapsulesResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => TimecapsuleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimecapsulesResponseToJson(
        TimecapsulesResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
