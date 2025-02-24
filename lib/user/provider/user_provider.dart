import 'package:dio/dio.dart';
import 'package:pico/common/auth/model/auth_model.dart';
import 'package:pico/common/auth/provider/auth_provider.dart';
import 'package:pico/common/auth/provider/secure_storage.dart';
import 'package:pico/common/model/custom_exception.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/provider/schedules_provider.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/repository/user_repository.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class User extends _$User {
  late final UserRepository repository = ref.read(userRepositoryProvider);
  late final SecureStorage storage = ref.read(secureStorageProvider);

  @override
  UserModelBase? build() {
    // repository = ref.read(userRepositoryProvider);
    // storage = ref.read(secureStorageProvider);

    // 초기 상태 설정 및 정보 가져오기
    getUserInfo();

    return UserModelLoading();
  }

  // 로그아웃
  Future<void> logout() async {
    // 유저 정보 지우기
    state = null;
    // 스케줄 캐싱 지우기
    ref.read(schedulesProvider.notifier).resetSchedules();
    // auth 초기화
    await ref.read(authProvider.notifier).authReset();
  }

  // 회원 탈퇴
  Future<void> deleteAccount() async {
    try {
      // 회원 탈퇴
      await repository.postDeleteAccount();
      logout();
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  // 유저 정보 가져오기
  Future<void> getUserInfo() async {
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
      print("유저 정보 가져올때 에러");
      print(e.toString());
      if (e.response != null) {
        // Server responded with an error
        final statusCode = e.response?.statusCode;
        final errorMessage = e.response?.data?['message'] ?? 'Unknown error';

        // state = UserModelError(message: 'Error $statusCode: $errorMessage');
        // state = null;
        // storage.storage.deleteAll();
        logout();
      } else {
        // state = null;
        // storage.storage.deleteAll();
        logout();
        // No response received (network error, timeout, etc.)
        // state = UserModelError(
        //     message: 'Network error: ${e.message ?? 'Unknown error'}');
      }
    } catch (e) {
      print("유저 정보 가져올때 에러");
      print(e.toString());
      // state = null;
      // storage.storage.deleteAll();
      logout();
      // Handle other exceptions
      // state = UserModelError(message: 'Unexpected error: $e');
    }
  }

  // 커플 끊기
  Future<void> unLinkCouple() async {
    try {
      // 커플 연결 해제
      await repository.postDeleteCoupleInfo();
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response.toString());
        throw CustomException(e.response.toString());
      }
    } catch (e) {
      throw CustomException("커플 해제에 실패했습니다");
    }
  }

  Future<void> updateUserProfile(imgFile) async {
    try {
      // 유저 프로필 변경
      final userInfo = await repository.postProfileImage(imgFile);

      state = userInfo;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 413) {
          throw CustomException("사진 용량을 줄여주세요");
        }
        throw CustomException(e.response.toString());
      }
    } catch (e) {
      throw CustomException("프로필 사진 변경에 실패했습니다");
    }
  }

  // 유저 정보 수정
  Future<void> updateUserInfo(body) async {
    try {
      // 유저 프로필 변경
      final userInfo = await repository.patchUserInfo(body);
      state = userInfo;
    } on DioException catch (e) {
      if (e.response != null) {
        throw CustomException(e.response.toString());
      }
    } catch (e) {
      throw CustomException("프로필 사진 변경에 실패했습니다");
    }
  }
}
