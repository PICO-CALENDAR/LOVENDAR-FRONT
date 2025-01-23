import 'package:json_annotation/json_annotation.dart';

part 'delete_repeat_schedule_body.g.dart';

@JsonSerializable()
class DeleteRepeatScheduleBody {
  final String repeatEndDate;

  DeleteRepeatScheduleBody({
    required this.repeatEndDate,
  });

  Map<String, dynamic> toJson() => _$DeleteRepeatScheduleBodyToJson(this);
}
