import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/date_operations.dart';
import 'package:pico/common/utils/extenstions.dart';

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

  // 특정 날짜에 해당하는 이벤트인지
  bool isEventOnDate({
    // required ScheduleModel schedule,
    required DateTime targetDate,
  }) {
    DateTime scheduleStartTime = super.startTime;
    DateTime scheduleEndTime = super.endTime;

    Duration duration = scheduleEndTime.difference(scheduleStartTime);

    while (scheduleStartTime.isBefore(targetDate) ||
        scheduleStartTime.isSameDate(targetDate)) {
      // 현재 타겟날짜가 시작 날짜와 끝 날짜 사이에 있는지 확인
      if ((scheduleStartTime.isSameDate(targetDate) ||
          targetDate.isAfter(scheduleStartTime) &&
              targetDate.isBefore(scheduleEndTime) ||
          scheduleEndTime.isSameDate(targetDate))) {
        return true;
      }

      switch (super.repeatType) {
        case RepeatType.DAILY:
          scheduleStartTime = scheduleStartTime.add(Duration(days: 1));
          scheduleEndTime = scheduleStartTime.add(duration);
          break;
        case RepeatType.WEEKLY:
          scheduleStartTime = scheduleStartTime.add(Duration(days: 7));
          scheduleEndTime = scheduleStartTime.add(duration);
          break;
        case RepeatType.BIWEEKLY:
          scheduleStartTime = scheduleStartTime.add(Duration(days: 14));
          scheduleEndTime = scheduleStartTime.add(duration);
          break;
        case RepeatType.MONTHLY:
          scheduleStartTime = DateTime(scheduleStartTime.year,
              scheduleStartTime.month + 1, scheduleStartTime.day);
          scheduleEndTime = scheduleEndTime.add(duration);
          break;
        case RepeatType.YEARLY:
          scheduleStartTime = DateTime(scheduleStartTime.year + 1,
              scheduleStartTime.month, scheduleStartTime.day);
          scheduleEndTime = scheduleStartTime.add(duration);
          break;
        default:
          return false;
      }
    }
    return false;
  }

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

  // 복사 생성자
  ScheduleModel.copyWith({
    required ScheduleModel original,
    int? scheduleId, // 변경된 타입에 맞춤
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    ScheduleType? category,
    bool? isAllDay,
    String? meetingPeople,
    bool? isRepeat,
    RepeatType? repeatType,
    DateTime? repeatStartDate, // nullable DateTime 처리
    DateTime? repeatEndDate, // nullable DateTime 처리
  }) : this(
          scheduleId: scheduleId ?? original.scheduleId,
          title: title ?? original.title,
          startTime: startTime ?? original.startTime,
          endTime: endTime ?? original.endTime,
          category: category ?? original.category,
          isAllDay: isAllDay ?? original.isAllDay,
          meetingPeople: meetingPeople ?? original.meetingPeople,
          isRepeat: isRepeat ?? original.isRepeat,
          repeatType: repeatType ?? original.repeatType,
          repeatStartDate: repeatStartDate ?? original.repeatStartDate,
          repeatEndDate: repeatEndDate ?? original.repeatEndDate,
        );

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);
}
