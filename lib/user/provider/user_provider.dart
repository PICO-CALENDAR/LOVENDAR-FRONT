import 'package:dio/dio.dart';
import 'package:pico/common/auth/provider/secure_storage.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/provider/schedules_provider.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/repository/user_repository.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class User extends _$User {
  late final UserRepository repository;
  late final SecureStorage storage;

  @override
  UserModelBase? build() {
    repository = ref.read(userRepositoryProvider);
    storage = ref.read(secureStorageProvider);

    // 초기 상태 설정 및 정보 가져오기
    getUserInfo();

    return UserModelLoading();
  }

  // 로그아웃
  void logOut() {
    storage.storage.deleteAll();
    state = null;
    // 스케줄 캐싱 지우기
    ref.read(schedulesProvider.notifier).resetSchedules();
  }

  // 회원 탈퇴
  void deleteAccount() async {
    try {
      // 회원 탈퇴
      await repository.postDeleteAccount();
      storage.storage.deleteAll();
      state = null;
      ref.read(schedulesProvider.notifier).resetSchedules();
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  // 유저 정보 가져오기
  void getUserInfo() async {
    final refreshToken = await storage.readRefreshToken();
    final accessToken = await storage.readAccessToken();

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    try {
      final resp = await repository.getUserInfo();
      state = resp;
    } on DioException catch (e) {
      if (e.response != null) {
        // Server responded with an error
        final statusCode = e.response?.statusCode;
        final errorMessage = e.response?.data?['message'] ?? 'Unknown error';

        // state = UserModelError(message: 'Error $statusCode: $errorMessage');
        state = null;
        storage.storage.deleteAll();
      } else {
        state = null;
        storage.storage.deleteAll();
        // No response received (network error, timeout, etc.)
        // state = UserModelError(
        //     message: 'Network error: ${e.message ?? 'Unknown error'}');
      }
    } catch (e) {
      state = null;
      storage.storage.deleteAll();
      // Handle other exceptions
      // state = UserModelError(message: 'Unexpected error: $e');
    }
  }

  // 커플 끊기
}
