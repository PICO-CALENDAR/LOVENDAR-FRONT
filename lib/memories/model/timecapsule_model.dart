import 'package:json_annotation/json_annotation.dart';
import 'package:lovendar/common/utils/date_operations.dart';

//  {
//       "memoryboxId": 0,
//       "isOpen": true,
//       "scheduleTitle": "string",
//       "scheduleStartTime": "2025-02-23T13:13:54.761Z",
//       "scheduleEndTime": "2025-02-23T13:13:54.761Z",
//       "opendate": "2025-02-23T13:13:54.761Z",
//       "letters": [
//         {
//           "letterId": 0,
//           "title": "string",
//           "content": "string"
//         }
//       ],
//       "photos": [
//         {
//           "photoId": 0,
//           "url": "string"
//         }
//       ],
//       "author": {
//         "userId": 0,
//         "name": "string",
//         "nickName": "string",
//         "profileImage": "string"
//       },
//       "toWhom": {
//         "userId": 0,
//         "name": "string",
//         "nickName": "string",
//         "profileImage": "string"
//       }
//     }

part 'timecapsule_model.g.dart';

@JsonSerializable()
class TimecapsuleModel {
  final int memoryboxId;
  final bool isOpen;
  final String scheduleTitle;
  @JsonKey(fromJson: dateTimeFromIsoString, toJson: dateTimeToIsoString)
  final DateTime scheduleStartTime;
  @JsonKey(fromJson: dateTimeFromIsoString, toJson: dateTimeToIsoString)
  final DateTime scheduleEndTime;
  @JsonKey(fromJson: dateTimeFromIsoString, toJson: dateTimeToIsoString)
  final DateTime opendate;
  final List<LetterModel> letters;
  final List<PhotoModel> photos;
  final UserCompactInfo author;
  final UserCompactInfo toWhom;

  TimecapsuleModel({
    required this.memoryboxId,
    required this.isOpen,
    required this.scheduleTitle,
    required this.scheduleStartTime,
    required this.scheduleEndTime,
    required this.opendate,
    required this.letters,
    required this.photos,
    required this.author,
    required this.toWhom,
  });

  factory TimecapsuleModel.fromJson(Map<String, dynamic> json) =>
      _$TimecapsuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimecapsuleModelToJson(this);
}

@JsonSerializable()
class LetterModel {
  final int letterId;
  final String title;
  final String content;

  LetterModel({
    required this.letterId,
    required this.title,
    required this.content,
  });

  factory LetterModel.fromJson(Map<String, dynamic> json) =>
      _$LetterModelFromJson(json);

  Map<String, dynamic> toJson() => _$LetterModelToJson(this);
}

@JsonSerializable()
class PhotoModel {
  final int photoId;
  final String url;

  PhotoModel({
    required this.photoId,
    required this.url,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);
}

@JsonSerializable()
class UserCompactInfo {
  final int userId;
  final String name;
  final String nickName;
  final String profileImage;

  UserCompactInfo({
    required this.userId,
    required this.name,
    required this.nickName,
    required this.profileImage,
  });

  factory UserCompactInfo.fromJson(Map<String, dynamic> json) =>
      _$UserCompactInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserCompactInfoToJson(this);
}
