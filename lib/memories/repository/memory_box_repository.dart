import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/common/dio/dio.dart';
import 'package:lovendar/common/schedule/model/schedules_response.dart';
import 'package:lovendar/memories/model/timecapsule_model.dart';
import 'package:lovendar/memories/model/timecapsules_response.dart';
import 'package:lovendar/memories/model/timecapsules_with_anni.dart';
import 'package:lovendar/memories/model/timecapsules_with_anni_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memory_box_repository.g.dart';

@Riverpod(keepAlive: true)
MemoryBoxRepository memoryBoxRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return MemoryBoxRepository(dio, baseUrl: "/api/v1/memorybox");
}

@RestApi()
abstract class MemoryBoxRepository {
  factory MemoryBoxRepository(Dio dio, {String? baseUrl}) =
      _MemoryBoxRepository;

  // 앞으로 다가올 3개월 기념일 조회
  @GET("/get/three/month/anniversaries")
  @Headers({
    'accessToken': 'true',
  })
  Future<SchedulesResponse> getUpcomingAnniversaries();

  // 나와 상대방의 전체 타임캡슐 조회
  @GET("/get/all")
  @Headers({
    'accessToken': 'true',
  })
  Future<TimecapsulesWithAnniResponse> getTimecapsules();

  // 나와 연인이 생성한 해당 기념일의 타입캡슐들을 조회
  @GET("/get/anniversary")
  @Headers({
    'accessToken': 'true',
  })
  Future<TimecapsulesWithAnni> getTimecapsulesByAnniversary(
    @Query('title') String title, // 특정 기념일의 이름을 쿼리로 전달
  );

  // 오픈 날짜가 지난 나의 타입캡슐들을 조회
  @GET("/get/opendate/past")
  @Headers({
    'accessToken': 'true',
  })
  Future<TimecapsulesResponse> getOpenedMyTimecapsules();

  // 오픈 날짜가 지나지 않은 나의 타입캡슐들을 조회
  @GET("/get/opendate/upcoming")
  @Headers({
    'accessToken': 'true',
  })
  Future<TimecapsulesResponse> getUpcomingMyTimecapsules();

  // 타임캡슐 생성
  @POST("/add")
  @MultiPart()
  @Headers({
    'accessToken': 'true',
  })
  Future<TimecapsuleModel> postTimeCapsule({
    @Part(name: 'scheduleId') required int scheduleId,
    @Part(name: 'scheduleStartTime') required String scheduleStartTime,
    @Part(name: 'scheduleEndTime') required String scheduleEndTime,
    @Part(name: 'letterTitle') required String letterTitle,
    @Part(name: 'letter') required String letter,
    @Part(name: 'photo') required List<MultipartFile> photo,
  });

  // 타임캡슐 수정
  @PATCH("/update/{memoryboxId}")
  @MultiPart()
  @Headers({
    'accessToken': 'true',
  })
  Future<TimecapsuleModel> editTimeCapsule({
    @Path() required String memoryboxId,
    @Part(name: 'scheduleId') int? scheduleId,
    @Part(name: 'scheduleStartTime') String? scheduleStartTime,
    @Part(name: 'scheduleEndTime') String? scheduleEndTime,
    @Part(name: 'letterTitle') String? letterTitle,
    @Part(name: 'letter') String? letter,
    @Part(name: 'photo') List<MultipartFile>? photo,
  });

  // 타임캡슐 삭제
  @DELETE("/delete/{memoryboxId}")
  @Headers({
    'accessToken': 'true',
  })
  Future<void> deleteTimeCapsule();
}
