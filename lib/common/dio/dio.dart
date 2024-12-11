import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/provider/secure_storage.dart';
import 'package:pico/user/model/register_body.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final String baseUrl = dotenv.env['SERVER_URL'] ?? '';
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );

  final secureStorage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      secureStorage: secureStorage,
      ref: ref,
    ),
  );

  return dio;
}

class CustomInterceptor extends Interceptor {
  final String baseUrl = dotenv.env['SERVER_URL'] ?? '';
  final SecureStorage secureStorage;
  final Ref ref;

  CustomInterceptor({
    required this.secureStorage,
    required this.ref,
  });

  // 1) 요청을 보낼때
  // 요청이 보내질때마다
  // 만약에 요청의 Header에 accessToken: true라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization: bearer $token으로
  // 헤더를 변경한다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri} ${options.data}');

    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await secureStorage.readAccessToken();

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await secureStorage.readRefreshToken();

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri} ${response.data}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await secureStorage.readRefreshToken();
    final accessToken = await secureStorage.readAccessToken();

    // refreshToken 아예 없으면
    // 당연히 에러를 던진다
    if (refreshToken == null || accessToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/api/v1/auth/reissue';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();
      print(baseUrl);

      try {
        final resp = await dio.post(
          '$baseUrl/api/v1/auth/reissue',
          data: {
            // body에 포함될 데이터 (JSON 형태로 전달)
            "accessToken": accessToken,
            "refreshToken": refreshToken,
          },
        );

        final newAccessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $newAccessToken',
        });

        await secureStorage.saveAccessToken(newAccessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (e) {
        // ref.read(authProvider.notifier).logout();

        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
