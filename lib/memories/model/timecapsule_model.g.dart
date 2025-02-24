// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timecapsule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimecapsuleModel _$TimecapsuleModelFromJson(Map<String, dynamic> json) =>
    TimecapsuleModel(
      memoryboxId: (json['memoryboxId'] as num).toInt(),
      isOpen: json['isOpen'] as bool,
      scheduleTitle: json['scheduleTitle'] as String,
      scheduleStartTime:
          dateTimeFromIsoString(json['scheduleStartTime'] as String),
      scheduleEndTime: dateTimeFromIsoString(json['scheduleEndTime'] as String),
      opendate: dateTimeFromIsoString(json['opendate'] as String),
      letters: (json['letters'] as List<dynamic>)
          .map((e) => LetterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      photos: (json['photos'] as List<dynamic>)
          .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      author: UserCompactInfo.fromJson(json['author'] as Map<String, dynamic>),
      toWhom: UserCompactInfo.fromJson(json['toWhom'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimecapsuleModelToJson(TimecapsuleModel instance) =>
    <String, dynamic>{
      'memoryboxId': instance.memoryboxId,
      'isOpen': instance.isOpen,
      'scheduleTitle': instance.scheduleTitle,
      'scheduleStartTime': dateTimeToIsoString(instance.scheduleStartTime),
      'scheduleEndTime': dateTimeToIsoString(instance.scheduleEndTime),
      'opendate': dateTimeToIsoString(instance.opendate),
      'letters': instance.letters,
      'photos': instance.photos,
      'author': instance.author,
      'toWhom': instance.toWhom,
    };

LetterModel _$LetterModelFromJson(Map<String, dynamic> json) => LetterModel(
      letterId: (json['letterId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$LetterModelToJson(LetterModel instance) =>
    <String, dynamic>{
      'letterId': instance.letterId,
      'title': instance.title,
      'content': instance.content,
    };

PhotoModel _$PhotoModelFromJson(Map<String, dynamic> json) => PhotoModel(
      photoId: (json['photoId'] as num).toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$PhotoModelToJson(PhotoModel instance) =>
    <String, dynamic>{
      'photoId': instance.photoId,
      'url': instance.url,
    };

UserCompactInfo _$UserCompactInfoFromJson(Map<String, dynamic> json) =>
    UserCompactInfo(
      userId: (json['userId'] as num).toInt(),
      name: json['name'] as String,
      nickName: json['nickName'] as String,
      profileImage: json['profileImage'] as String,
    );

Map<String, dynamic> _$UserCompactInfoToJson(UserCompactInfo instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'nickName': instance.nickName,
      'profileImage': instance.profileImage,
    };
