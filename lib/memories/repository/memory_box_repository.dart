import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/dio/dio.dart';
import 'package:pico/common/schedule/model/schedules_response.dart';
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

  // // 유저 프로필 이미지 업데이트
  // @POST("/update/profile/image")
  // @MultiPart()
  // @Headers({
  //   'accessToken': 'true',
  // })
  // Future<void> postProfileImage(
  //   @Part(name: 'file') List<MultipartFile> file,
  // );

  // // 초대 코드 생성
  // @GET("/make/invite/code")
  // @Headers({
  //   'accessToken': 'true',
  // })
  // Future<void> getInviteCode();

  // // 커플 연결
  // @POST("/make/couple")
  // @Headers({
  //   'accessToken': 'true',
  // })
  // Future<void> postLinkingCouple(
  //   @Body() void body,
  // );

  // // 회원가입
  // @POST("/register/{id}")
  // Future<void> postRegister({
  //   @Path() required String id,
  //   @Body() required void body,
  // });

  // // 회원탈퇴
  // @DELETE("/delete")
  // @Headers({
  //   'accessToken': 'true',
  // })
  // Future<void> postDeleteAccount();

  // // 커플 관계 끊기
  // @POST("/delete/couple")
  // @Headers({
  //   'accessToken': 'true',
  // })
  // Future<void> postDeleteCoupleInfo();
}
