// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAuthRequest _$GoogleAuthRequestFromJson(Map<String, dynamic> json) =>
    GoogleAuthRequest(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      isRegistered: json['isRegistered'] as bool,
    );

Map<String, dynamic> _$GoogleAuthRequestToJson(GoogleAuthRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'isRegistered': instance.isRegistered,
    };
