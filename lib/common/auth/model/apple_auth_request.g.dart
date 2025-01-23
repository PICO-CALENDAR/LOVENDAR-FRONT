// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppleAuthBody _$AppleAuthBodyFromJson(Map<String, dynamic> json) =>
    AppleAuthBody(
      idToken: json['idToken'] as String,
      authorizationCode: json['authorizationCode'] as String,
    );

Map<String, dynamic> _$AppleAuthBodyToJson(AppleAuthBody instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'authorizationCode': instance.authorizationCode,
    };
