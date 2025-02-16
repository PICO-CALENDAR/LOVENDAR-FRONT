import 'package:json_annotation/json_annotation.dart';

part 'delete_couple_response.g.dart';

@JsonSerializable()
class DeleteCoupleResponse {
  final List<CoupleInfo> couple;

  DeleteCoupleResponse({
    required this.couple,
  });

  factory DeleteCoupleResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteCoupleResponseFromJson(json);

  // toJson 메서드
  Map<String, dynamic> toJson() => _$DeleteCoupleResponseToJson(this);
}

@JsonSerializable()
class CoupleInfo {
  final int userId;
  final String name;

  CoupleInfo({
    required this.userId,
    required this.name,
  });

  factory CoupleInfo.fromJson(Map<String, dynamic> json) =>
      _$CoupleInfoFromJson(json);

  // toJson 메서드
  Map<String, dynamic> toJson() => _$CoupleInfoToJson(this);
}
