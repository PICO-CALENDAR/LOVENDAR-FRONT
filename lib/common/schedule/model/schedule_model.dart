import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/utils/date_operations.dart';
import 'package:lovendar/common/utils/extenstions.dart';

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
      // // 현재 타겟날짜가 시작 날짜와 끝 날짜 사이에 있는지 확인
      // if ((scheduleStartTime.isSameDate(targetDate) ||
      //     targetDate.isAfter(scheduleStartTime) &&
      //         targetDate.isBefore(scheduleEndTime) ||
      //     scheduleEndTime.isSameDate(targetDate))) {
      //   return true;
      // }

      // 현재 타겟 날짜가 시작 날짜와 끝 날짜 사이에 있는지 확인
      if ((scheduleStartTime.isSameDate(targetDate) ||
              (targetDate.isAfter(scheduleStartTime) &&
                  (targetDate.isBefore(scheduleEndTime) ||
                      scheduleEndTime.isSameDate(targetDate)))) &&
          (repeatEndDate == null ||
              targetDate.withoutTime.isBefore(repeatEndDate!.withoutTime))) {
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

  // 특정 날짜에 해당하는 스케줄이면, 알맞은 허위객체 생성
  ScheduleModel? copyScheduleOnDate({
    // required ScheduleModel schedule,
    required DateTime targetDate,
  }) {
    DateTime scheduleStartTime = super.startTime;
    DateTime scheduleEndTime = super.endTime;

    Duration duration = scheduleEndTime.difference(scheduleStartTime);

    // 보여주는 타겟날짜가 스케줄의 종료일자보다 이전이 아닐때
    if (repeatEndDate != null) {
      if (!targetDate.withoutTime.isBefore(repeatEndDate!.withoutTime)) {
        return null;
      }
    }
    while (scheduleStartTime.isBefore(targetDate) ||
        scheduleStartTime.isSameDate(targetDate)) {
      // 현재 타겟날짜가 시작 날짜와 끝 날짜 사이에 있는지 확인
      if ((scheduleStartTime.isSameDate(targetDate) ||
          targetDate.isAfter(scheduleStartTime) &&
              targetDate.isBefore(scheduleEndTime) ||
          scheduleEndTime.isSameDate(targetDate))) {
        return ScheduleModel.copyWith(
          original: this,
          startTime: DateTime(
              scheduleStartTime.year,
              scheduleStartTime.month,
              scheduleStartTime.day,
              super.startTime.hour,
              super.startTime.minute),
          endTime: DateTime(scheduleEndTime.year, scheduleEndTime.month,
              scheduleEndTime.day, super.endTime.hour, super.endTime.minute),
        );
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
          return null;
      }
    }
    return null;
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

  // ✅ 빈 ScheduleModel 객체 반환 (기본값 설정)
  static ScheduleModel empty() {
    return ScheduleModel(
      scheduleId: -999, // -1은 빈 객체를 나타내는 특별한 ID
      title: '일정 없음', // 기본 제목
      isAllDay: false,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 1)), // 기본값: 1시간 후 종료
      category: ScheduleType.OURS, // 기본 카테고리 설정
      isRepeat: false,
      repeatType: null,
      repeatStartDate: null,
      repeatEndDate: null,
    );
  }

  /// targetDate를 기준으로 시작 시간을 변경하고, 기존 duration을 유지하여 새 스케줄 생성
  ScheduleModel copyWithNewDate({required DateTime targetDate}) {
    Duration duration = super.endTime.difference(super.startTime);

    return ScheduleModel.copyWith(
      original: this,
      startTime: DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        super.startTime.hour,
        super.startTime.minute,
      ),
      endTime: DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        super.startTime.hour,
        super.startTime.minute,
      ).add(duration),
    );
  }

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
