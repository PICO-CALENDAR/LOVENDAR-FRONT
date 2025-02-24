// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timecapsules_with_anni_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimecapsulesWithAnniResponse _$TimecapsulesWithAnniResponseFromJson(
        Map<String, dynamic> json) =>
    TimecapsulesWithAnniResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => TimecapsulesWithAnni.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimecapsulesWithAnniResponseToJson(
        TimecapsulesWithAnniResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
