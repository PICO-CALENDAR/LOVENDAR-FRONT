import 'package:json_annotation/json_annotation.dart';
import 'package:pico/memories/model/timecapsule_model.dart';

part 'timecapsules_with_anni.g.dart';

@JsonSerializable()
class TimecapsulesWithAnni {
  final String anniversary;
  final List<TimecapsuleModel> timeCapsules;

  TimecapsulesWithAnni({
    required this.anniversary,
    required this.timeCapsules,
  });

  factory TimecapsulesWithAnni.fromJson(Map<String, dynamic> json) =>
      _$TimecapsulesWithAnniFromJson(json);

  Map<String, dynamic> toJson() => _$TimecapsulesWithAnniToJson(this);
}
