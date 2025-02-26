import 'package:json_annotation/json_annotation.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';
import 'package:lovendar/common/utils/date_operations.dart';

part 'update_schedule_body.g.dart';

@JsonSerializable()
class UpdateScheduleBody {
  final String? title;
  @JsonKey(toJson: dateTimeToIsoStringNullable)
  final DateTime? startTime;
  @JsonKey(toJson: dateTimeToIsoStringNullable)
  final DateTime? endTime;
  final ScheduleType? category;
  final bool? isAllDay;
  final String? meetingPeople;
  final bool? isRepeat;
  final RepeatType? repeatType;

  UpdateScheduleBody({
    this.title,
    this.startTime,
    this.endTime,
    this.category,
    this.isAllDay,
    this.meetingPeople,
    this.isRepeat,
    this.repeatType,
  });

  Map<String, dynamic> toJson() => _$UpdateScheduleBodyToJson(this);
}
