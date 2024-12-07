import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor {
  // 1) 요청을 보낼때
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('[REQ] [${options.method}] ${options.uri}');
    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    return super.onError(err, handler);
  }
}
