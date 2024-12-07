import 'package:dio/dio.dart';
import 'package:pico/user/model/google_auth_request.dart';
import 'package:pico/user/model/google_auth_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_repository.g.dart';

@RestApi(baseUrl: "/api/v1/auth")
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  @POST("/app/login/google")
  Future<GoogleAuthResponse> postGoogleSignin(
    @Body() GoogleAuthRequest authReq,
  );
}
