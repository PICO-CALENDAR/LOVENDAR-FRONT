import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/common/auth/model/google_auth_response.dart';
import 'package:lovendar/common/dio/dio.dart';
import 'package:lovendar/common/schedule/model/delete_repeat_schedule_body.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';
import 'package:lovendar/common/schedule/model/schedule_response.dart';
import 'package:lovendar/common/schedule/model/schedules_response.dart';
import 'package:lovendar/common/schedule/model/update_schedule_body.dart';
import 'package:lovendar/user/model/register_body.dart';
import 'package:lovendar/user/model/user_model.dart';
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
  @PATCH("/update/{scheduleId}")
  @Headers({
    'accessToken': 'true',
  })
  Future<ScheduleResponse> postUpdateSchedule({
    @Path() required String scheduleId,
    @Body() required UpdateScheduleBody body,
  });

  // 반복 일정 중 현재 선택된 일정만 수정
  @POST("/update/only/{scheduleId}")
  @Headers({
    'accessToken': 'true',
  })
  Future<ScheduleResponse> postUpdateSelectedRepeatScheduleOnly({
    @Path() required String scheduleId,
    @Body() required UpdateScheduleBody body,
  });

  // 반복 일정 중 현재 선택된 일정 및 이후 반복 일정 일괄 수정
  @POST("/update/after/{scheduleId}")
  @Headers({
    'accessToken': 'true',
  })
  Future<ScheduleResponse> postUpdateSelectedAndAfterRepeatSchedule({
    @Path() required String scheduleId,
    @Body() required UpdateScheduleBody body,
  });

  // // 일정 수정
  // @PATCH("/update/{scheduleId}")
  // @Headers({
  //   'accessToken': 'true',
  // })
  // Future<ScheduleResponse> postUpdateSchedule({
  //   @Path() required String scheduleId,
  //   @Body() required UpdateScheduleBody body,
  // });

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
  @Headers({
    'accessToken': 'true',
  })
  Future<ScheduleResponse> postDeleteRepeatSchedule({
    @Path() required String scheduleId,
    @Body() required DeleteRepeatScheduleBody body,
  });
}
