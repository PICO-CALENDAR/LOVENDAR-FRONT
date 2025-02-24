import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/model/google_auth_response.dart';
import 'package:pico/common/dio/dio.dart';
import 'package:pico/user/model/delete_couple_response.dart';
import 'package:pico/user/model/invite_code_model.dart';
import 'package:pico/user/model/register_body.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio, baseUrl: "/api/v1/users");
}

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String? baseUrl}) = _UserRepository;

  // 유저 정보 조회
  @GET("/info")
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getUserInfo();

  // 유저 정보 수정
  @PATCH("/info")
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> patchUserInfo(
    @Body() RegisterBody body,
  );

  // 유저 프로필 이미지 업데이트
  @POST("/update/profile/image")
  @MultiPart()
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> postProfileImage(
    @Part(name: 'file') List<MultipartFile> file,
  );

  // 초대 코드 생성
  @GET("/make/invite/code")
  @Headers({
    'accessToken': 'true',
  })
  Future<InviteCodeModel> getInviteCode();

  // 커플 연결
  @POST("/make/couple")
  @Headers({
    'accessToken': 'true',
  })
  Future<void> postLinkingCouple(
    @Body() InviteCodeModel body,
  );

  // 회원가입
  @POST("/register/{id}")
  Future<AuthResponse> postRegister({
    @Path() required String id,
    @Body() required RegisterBody body,
  });

  // 회원탈퇴
  @DELETE("/delete")
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> postDeleteAccount();

  // 커플 관계 끊기
  @POST("/delete/couple")
  @Headers({
    'accessToken': 'true',
  })
  Future<DeleteCoupleResponse> postDeleteCoupleInfo();
}
