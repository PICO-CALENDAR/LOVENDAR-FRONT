import 'package:json_annotation/json_annotation.dart';
import 'package:lovendar/memories/model/timecapsule_model.dart';

part 'timecapsules_response.g.dart';

@JsonSerializable()
class TimecapsulesResponse {
  final List<TimecapsuleModel> items;

  TimecapsulesResponse({
    required this.items,
  });

  factory TimecapsulesResponse.fromJson(Map<String, dynamic> json) =>
      _$TimecapsulesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TimecapsulesResponseToJson(this);
}
