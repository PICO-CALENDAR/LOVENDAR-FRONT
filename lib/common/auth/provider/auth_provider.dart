import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pico/common/auth/model/auth_model.dart';
import 'package:pico/common/auth/model/google_auth_request.dart';
import 'package:pico/common/auth/model/google_auth_response.dart';
import 'package:pico/common/auth/provider/secure_storage.dart';
import 'package:pico/common/auth/repository/auth_repository.dart';
import 'package:pico/common/auth/repository/social_login_repository.dart';
import 'package:pico/user/provider/user_provider.dart';
import 'package:pico/user/repository/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final AuthRepository authRepository = ref.read(authRepositoryProvider);
  late final SecureStorage secureStorage = ref.read(secureStorageProvider);

  @override
  AuthModelBase? build() {
    return null;
  }

  Future<void> register(AuthResponse response) async {
    await secureStorage.saveAccessToken(response.accessToken);
    await secureStorage.saveRefreshToken(response.refreshToken);
    state = AuthModel(
        id: response.id,
        name: response.name,
        isRegistered: response.isRegistered);
  }

  logout() {
    ref.read(userProvider.notifier).logOut();
  }

  googleLogin(BuildContext context) async {
    try {
      state = AuthModelLoading();
      final idToken = await SocialLoginRepository()
          .socialLogin(socialType: SocialType.google);

      print("idToken : $idToken");

      if (idToken == null) {
        if (context.mounted) {
          return context.go("/login");
        }
      }

      final GoogleAuthBody authReq = GoogleAuthBody(idToken: idToken!);

      // print("authReq: ${authReq.toJson()}");

      final response = await authRepository.postGoogleSignin(authReq);

      // 가입되어 있지 않은 상태
      if (!response.isRegistered) {
        state = AuthModel(
            id: response.id,
            name: response.name,
            isRegistered: response.isRegistered);

        ref.read(userProvider.notifier).getUserInfo();
        // 로그인 상태 업데이트
        if (context.mounted) {
          context.go("/register");
        }
      } else {
        // 가입된 상태
        await secureStorage.saveAccessToken(response.accessToken);
        await secureStorage.saveRefreshToken(response.refreshToken);
        state = AuthModel(
            id: response.id,
            name: response.name,
            isRegistered: response.isRegistered);
        ref.read(userProvider.notifier).getUserInfo();
        // 로그인 상태 업데이트
        if (context.mounted) {
          context.go("/");
        }
      }
    } catch (e) {
      print("로그인 에러");
      state = null;
    }
  }
}
