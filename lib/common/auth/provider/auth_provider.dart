import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pico/common/auth/model/auth_model.dart';
import 'package:pico/common/auth/model/google_auth_request.dart';
import 'package:pico/common/auth/model/google_auth_response.dart';
import 'package:pico/common/auth/provider/secure_storage.dart';
import 'package:pico/common/auth/repository/auth_repository.dart';
import 'package:pico/common/auth/repository/social_login_repository.dart';
import 'package:pico/user/provider/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final AuthRepository authRepository;
  late final SecureStorage secureStorage;

  @override
  AuthModelBase build() {
    authRepository = ref.read(authRepositoryProvider);
    secureStorage = ref.read(secureStorageProvider);

    return AuthModelLoading();
  }

  register(BuildContext context, AuthResponse response) async {
    await secureStorage.saveAccessToken(response.accessToken);
    await secureStorage.saveRefreshToken(response.refreshToken);
    state = AuthModel(
        id: response.id,
        name: response.name,
        isRegistered: response.isRegistered);
    // 로그인 상태 업데이트
    if (context.mounted) {
      context.go("/");
    }
  }

  logout() {
    ref.read(userProvider.notifier).logOut();
  }

  googleLogin(BuildContext context) async {
    final idToken = await SocialLoginRepository()
        .socialLogin(socialType: SocialType.google);

    if (idToken == null) {
      if (context.mounted) {
        return context.go("/login");
      }
    }

    final GoogleAuthBody authReq = GoogleAuthBody(idToken: idToken!);

    final response = await authRepository.postGoogleSignin(authReq);

    // 가입되어 있지 않은 상태
    if (!response.isRegistered) {
      state = AuthModel(
          id: response.id,
          name: response.name,
          isRegistered: response.isRegistered);
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
  }
}
