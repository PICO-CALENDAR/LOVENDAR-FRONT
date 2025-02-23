// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timecapsule_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimecapsuleForm _$TimecapsuleFormFromJson(Map<String, dynamic> json) =>
    TimecapsuleForm(
      schedule: json['schedule'] == null
          ? null
          : ScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
      photo: json['photo'] as String?,
      letterTitle: json['letterTitle'] as String?,
      letter: json['letter'] as String?,
    );

Map<String, dynamic> _$TimecapsuleFormToJson(TimecapsuleForm instance) =>
    <String, dynamic>{
      'schedule': instance.schedule,
      'photo': instance.photo,
      'letterTitle': instance.letterTitle,
      'letter': instance.letter,
    };
