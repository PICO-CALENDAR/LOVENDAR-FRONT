import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/date_operations.dart';

part 'schedule_model.g.dart';

enum RepeatType {
  @JsonValue('DAILY')
  DAILY,
  @JsonValue('WEEKLY')
  WEEKLY,
  @JsonValue('MONTHLY')
  MONTHLY,
  @JsonValue('YEARLY')
  YEARLY,
  @JsonValue('BIWEEKLY')
  BIWEEKLY;
}

enum ScheduleType {
  @JsonValue('MINE')
  MINE,
  @JsonValue('YOURS')
  YOURS,
  @JsonValue('OURS')
  OURS,
}

extension ScheduleTypeExtension on ScheduleType {
  String getName() {
    switch (this) {
      case ScheduleType.MINE:
        return '나';
      case ScheduleType.YOURS:
        return '상대';
      case ScheduleType.OURS:
        return '우리';
    }
  }
}

extension RepeatTypeExtension on RepeatType {
  String getName() {
    switch (this) {
      case RepeatType.DAILY:
        return '매일';
      case RepeatType.WEEKLY:
        return '매주';
      case RepeatType.BIWEEKLY:
        return '격주';
      case RepeatType.MONTHLY:
        return '매달';
      case RepeatType.YEARLY:
        return '매년';
    }
  }
}

@JsonSerializable()
class ScheduleModelBase {
  final String title;
  @JsonKey(fromJson: dateTimeFromIsoString, toJson: dateTimeToIsoString)
  final DateTime startTime;
  @JsonKey(fromJson: dateTimeFromIsoString, toJson: dateTimeToIsoString)
  final DateTime endTime;
  final ScheduleType category;
  final bool isAllDay;
  final String? meetingPeople;
  final bool isRepeat;
  final RepeatType? repeatType;

  ScheduleModelBase({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.isAllDay,
    this.meetingPeople,
    required this.isRepeat,
    this.repeatType,
  });

  factory ScheduleModelBase.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelBaseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleModelBaseToJson(this);
}

@JsonSerializable()
class ScheduleModel extends ScheduleModelBase {
  final int scheduleId;
  @JsonKey(
      fromJson: dateTimeFromIsoStringNullable,
      toJson: dateTimeToIsoStringNullable)
  final DateTime? repeatStartDate;
  @JsonKey(
      fromJson: dateTimeFromIsoStringNullable,
      toJson: dateTimeToIsoStringNullable)
  final DateTime? repeatEndDate;

  Duration get durationFromMidnight {
    DateTime midnight =
        DateTime(startTime.year, startTime.month, startTime.day);
    return startTime.difference(midnight);
  }

  Duration get duration => endTime.difference(startTime);
  Color get color => AppTheme.getColorByScheduleType(category);

  ScheduleModel({
    required this.scheduleId,
    required super.title,
    required super.isAllDay,
    required super.startTime,
    required super.endTime,
    required super.category,
    super.meetingPeople,
    required super.isRepeat,
    super.repeatType,
    this.repeatStartDate,
    this.repeatEndDate,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);
}
