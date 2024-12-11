import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/model/google_auth_response.dart';
import 'package:pico/common/dio/dio.dart';
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
  // @PATCH("/info")
  // @Headers({
  //   'accessToken': 'true',
  // })
  // Future<UserModel> patchUserInfo(
  //   @Body() RegisterBody body,
  // );

  //  회원가입
  @POST("/register/{id}")
  Future<AuthResponse> postRegister({
    @Path() required String id,
    @Body() required RegisterBody body,
  });
}
