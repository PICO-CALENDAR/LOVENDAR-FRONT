import 'package:json_annotation/json_annotation.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';

part 'schedules_response.g.dart';

@JsonSerializable()
class SchedulesResponse {
  final List<ScheduleModel> items;

  SchedulesResponse({
    required this.items,
  });

  factory SchedulesResponse.fromJson(Map<String, dynamic> json) =>
      _$SchedulesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SchedulesResponseToJson(this);
}
