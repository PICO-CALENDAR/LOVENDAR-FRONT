import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/model/google_auth_request.dart';
import 'package:pico/common/auth/model/google_auth_response.dart';
import 'package:pico/common/dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio, baseUrl: "/api/v1/auth");
}

@RestApi()
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String? baseUrl}) = _AuthRepository;

  @POST("/app/login/google")
  Future<AuthResponse> postGoogleSignin(
    @Body() GoogleAuthBody authReq,
  );
}
