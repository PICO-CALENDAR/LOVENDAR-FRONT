// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_schedule_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateScheduleBody _$UpdateScheduleBodyFromJson(Map<String, dynamic> json) =>
    UpdateScheduleBody(
      title: json['title'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      category: $enumDecodeNullable(_$ScheduleTypeEnumMap, json['category']),
      isAllDay: json['isAllDay'] as bool?,
      meetingPeople: json['meetingPeople'] as String?,
      isRepeat: json['isRepeat'] as bool?,
      repeatType: $enumDecodeNullable(_$RepeatTypeEnumMap, json['repeatType']),
    );

Map<String, dynamic> _$UpdateScheduleBodyToJson(UpdateScheduleBody instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startTime': dateTimeToIsoStringNullable(instance.startTime),
      'endTime': dateTimeToIsoStringNullable(instance.endTime),
      'category': _$ScheduleTypeEnumMap[instance.category],
      'isAllDay': instance.isAllDay,
      'meetingPeople': instance.meetingPeople,
      'isRepeat': instance.isRepeat,
      'repeatType': _$RepeatTypeEnumMap[instance.repeatType],
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.MINE: 'MINE',
  ScheduleType.YOURS: 'YOURS',
  ScheduleType.OURS: 'OURS',
};

const _$RepeatTypeEnumMap = {
  RepeatType.DAILY: 'DAILY',
  RepeatType.WEEKLY: 'WEEKLY',
  RepeatType.MONTHLY: 'MONTHLY',
  RepeatType.YEARLY: 'YEARLY',
  RepeatType.BIWEEKLY: 'BIWEEKLY',
};
