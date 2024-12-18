// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedules_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchedulesResponse _$SchedulesResponseFromJson(Map<String, dynamic> json) =>
    SchedulesResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SchedulesResponseToJson(SchedulesResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
