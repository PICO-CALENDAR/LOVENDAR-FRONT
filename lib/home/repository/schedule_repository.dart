import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/model/google_auth_response.dart';
import 'package:pico/common/dio/dio.dart';
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

  // 일정 추가
  @GET("/add")
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getUserInfo();

  @POST("/register/{id}")
  Future<AuthResponse> postRegister({
    @Path() required String id,
    @Body() required RegisterBody body,
  });
}
