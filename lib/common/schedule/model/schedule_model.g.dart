// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModelBase _$ScheduleModelBaseFromJson(Map<String, dynamic> json) =>
    ScheduleModelBase(
      title: json['title'] as String,
      startTime: dateTimeFromIsoString(json['startTime'] as String),
      endTime: dateTimeFromIsoString(json['endTime'] as String),
      category: $enumDecode(_$ScheduleTypeEnumMap, json['category']),
      isAllDay: json['isAllDay'] as bool,
      meetingPeople: json['meetingPeople'] as String?,
      isRepeat: json['isRepeat'] as bool,
      repeatType: $enumDecodeNullable(_$RepeatTypeEnumMap, json['repeatType']),
    );

Map<String, dynamic> _$ScheduleModelBaseToJson(ScheduleModelBase instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startTime': dateTimeToIsoString(instance.startTime),
      'endTime': dateTimeToIsoString(instance.endTime),
      'category': _$ScheduleTypeEnumMap[instance.category]!,
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

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      scheduleId: (json['scheduleId'] as num).toInt(),
      title: json['title'] as String,
      isAllDay: json['isAllDay'] as bool,
      startTime: dateTimeFromIsoString(json['startTime'] as String),
      endTime: dateTimeFromIsoString(json['endTime'] as String),
      category: $enumDecode(_$ScheduleTypeEnumMap, json['category']),
      meetingPeople: json['meetingPeople'] as String?,
      isRepeat: json['isRepeat'] as bool,
      repeatType: $enumDecodeNullable(_$RepeatTypeEnumMap, json['repeatType']),
      repeatStartDate:
          dateTimeFromIsoStringNullable(json['repeatStartDate'] as String?),
      repeatEndDate:
          dateTimeFromIsoStringNullable(json['repeatEndDate'] as String?),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startTime': dateTimeToIsoString(instance.startTime),
      'endTime': dateTimeToIsoString(instance.endTime),
      'category': _$ScheduleTypeEnumMap[instance.category]!,
      'isAllDay': instance.isAllDay,
      'meetingPeople': instance.meetingPeople,
      'isRepeat': instance.isRepeat,
      'repeatType': _$RepeatTypeEnumMap[instance.repeatType],
      'scheduleId': instance.scheduleId,
      'repeatStartDate': dateTimeToIsoStringNullable(instance.repeatStartDate),
      'repeatEndDate': dateTimeToIsoStringNullable(instance.repeatEndDate),
    };
