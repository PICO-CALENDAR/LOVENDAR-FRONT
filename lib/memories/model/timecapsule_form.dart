// scheduleId
// integer($int64)
// 관련된 일정 원본 ID

// scheduleStartTime
// string($date-time)
// 일정 시작 시간

// scheduleEndTime
// string($date-time)
// 일정 종료 시간

// letter *
// string
// 편지

// photo
// string($binary)

import 'package:json_annotation/json_annotation.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';

part 'timecapsule_form.g.dart';

@JsonSerializable()
class TimecapsuleForm {
  final ScheduleModel? schedule;
  final String? photo;
  final String? letter;

  TimecapsuleForm({
    this.schedule,
    this.photo,
    this.letter,
  });

  TimecapsuleForm copyWith({
    ScheduleModel? schedule,
    String? photo,
    String? letter,
  }) {
    return TimecapsuleForm(
      schedule: schedule ?? this.schedule,
      photo: photo ?? this.photo,
      letter: letter ?? this.letter,
    );
  }

  Map<String, dynamic> toJson() => _$TimecapsuleFormToJson(this);
}
