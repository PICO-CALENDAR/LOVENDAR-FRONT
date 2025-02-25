import 'package:json_annotation/json_annotation.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';

part 'schedule_response.g.dart';

@JsonSerializable()
class ScheduleResponse {
  final bool success;
  final ScheduleModel schedule;

  ScheduleResponse({
    required this.success,
    required this.schedule,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);
}
