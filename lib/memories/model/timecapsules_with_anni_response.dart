import 'package:json_annotation/json_annotation.dart';
import 'package:lovendar/memories/model/timecapsules_with_anni.dart';

part 'timecapsules_with_anni_response.g.dart';

@JsonSerializable()
class TimecapsulesWithAnniResponse {
  final List<TimecapsulesWithAnni> items;

  TimecapsulesWithAnniResponse({
    required this.items,
  });

  factory TimecapsulesWithAnniResponse.fromJson(Map<String, dynamic> json) =>
      _$TimecapsulesWithAnniResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TimecapsulesWithAnniResponseToJson(this);
}
