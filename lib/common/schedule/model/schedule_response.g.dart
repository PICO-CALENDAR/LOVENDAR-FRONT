// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    ScheduleResponse(
      success: json['success'] as bool,
      schedule:
          ScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'schedule': instance.schedule,
    };
