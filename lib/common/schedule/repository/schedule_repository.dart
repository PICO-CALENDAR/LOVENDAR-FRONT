import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/model/google_auth_response.dart';
import 'package:pico/common/dio/dio.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/model/schedule_response.dart';
import 'package:pico/common/schedule/model/schedules_response.dart';
import 'package:pico/user/model/register_body.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_repository.g.dart';

@Riverpod(keepAlive: true)
ScheduleRepository scheduleRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ScheduleRepository(dio, baseUrl: "/api/v1/schedule");
}

@RestApi()
abstract class ScheduleRepository {
  factory ScheduleRepository(Dio dio, {String? baseUrl}) = _ScheduleRepository;

  // 일정 조회 (해당 주)
  @GET("/get/today/schedules")
  @Headers({
    'accessToken': 'true',
  })
  Future<SchedulesResponse> getSchedulesByToday(
    @Query('todayDate') String todayDate,
  );

  // 일정 조회 (해당 연도)
  @GET("/get/year/schedules")
  @Headers({
    'accessToken': 'true',
  })
  Future<SchedulesResponse> getSchedulesByYear(
    @Query('year') String year,
  );

  // 일정 세부 조회
  @GET("/get/detail/{scheduleId}")
  @Headers({
    'accessToken': 'true',
  })
  Future<ScheduleResponse> getScheduleDetail(
    @Path() String scheduleId,
  );

  // 일정 추가
  @POST("/add")
  @Headers({
    'accessToken': 'true',
  })
  Future<ScheduleResponse> postAddSchedule(
    @Body() ScheduleModelBase body,
  );

  // 일정 수정
  @POST("/update")
  @Headers({
    'accessToken': 'true',
  })
  Future<ScheduleResponse> postUpdateSchedule();

  // 일정 삭제
  @POST("/delete/{scheduleId}")
  @Headers({
    'accessToken': 'true',
  })
  Future<ScheduleResponse> postDeleteSchedule({
    @Path() required String scheduleId,
  });

  // 반복 일정 삭제
  @POST("/delete/repeat/{scheduleId}")
  Future<ScheduleResponse> postDeleteRepeatSchedule({
    @Path() required String scheduleId,
    @Body() required RegisterBody body,
  });
}
