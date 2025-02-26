import 'package:dio/dio.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';

class TimecapsuleForm {
  final ScheduleModel? schedule;
  final String? photo;
  final String? letterTitle;
  final String? letter;

  TimecapsuleForm({
    this.schedule,
    this.photo,
    this.letterTitle,
    this.letter,
  });

  TimecapsuleForm copyWith({
    ScheduleModel? schedule,
    String? photo,
    String? letterTitle,
    String? letter,
  }) {
    return TimecapsuleForm(
      schedule: schedule ?? this.schedule,
      photo: photo ?? this.photo,
      letterTitle: letterTitle ?? this.letterTitle,
      letter: letter ?? this.letter,
    );
  }
}
