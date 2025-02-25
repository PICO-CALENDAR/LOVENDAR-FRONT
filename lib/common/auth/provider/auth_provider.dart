import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/model/apple_auth_request.dart';

import 'package:pico/common/auth/model/auth_model.dart';
import 'package:pico/common/auth/model/google_auth_request.dart';
import 'package:pico/common/auth/model/google_auth_response.dart';
import 'package:pico/common/auth/provider/secure_storage.dart';
import 'package:pico/common/auth/repository/auth_repository.dart';
import 'package:pico/common/auth/repository/social_login_repository.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';
// part 'auth_provider.g.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthProvider(
    ref: ref,
    authRepository: authRepository,
    secureStorage: secureStorage,
  );
});

// Notifier 클래스
class AuthProvider extends StateNotifier<AuthModelBase?> {
  final Ref ref;
  final AuthRepository authRepository;
  final SecureStorage secureStorage;

  AuthProvider({
    required this.ref,
    required this.authRepository,
    required this.secureStorage,
  }) : super(AuthModelInitial()) {
    init();
  }

  /// 초기화 메서드 (await 사용 가능)
  void init() async {
    try {
      await ref.read(userProvider.notifier).getUserInfo();
      if (ref.read(userProvider) is UserModel) {
        state = AuthModel(
          isRegistered: true,
          isLoggedIn: true,
        );
      } else {
        state = null;
      }
    } catch (e) {
      state = null;
    }
  }

  Future<void> register(AuthResponse response) async {
    await secureStorage.saveAccessToken(response.accessToken);
    await secureStorage.saveRefreshToken(response.refreshToken);
    state = AuthModel(
      id: response.id,
      isRegistered: response.isRegistered,
      isLoggedIn: false,
    );
  }

  authReset() async {
    state = null;
    await secureStorage.storage.deleteAll();
  }

  resetBeforeRegister() {
    state = null;
  }

  appleLogin(BuildContext context) async {
    try {
      state = AuthModelLoading();
      final authInfo = await SocialLoginRepository()
          .socialLogin(socialType: SocialType.apple);
      if (authInfo == null) {
        return;
      }

      final AppleAuthBody authReq = AppleAuthBody(
        idToken: authInfo[0],
        authorizationCode: authInfo[1],
      );

      final response = await authRepository.postAppleSignin(authReq);

      print(response.toString());

      // 가입되어 있지 않은 상태
      if (!response.isRegistered) {
        state = AuthModel(
          id: response.id,
          isRegistered: response.isRegistered,
          isLoggedIn: false,
        );

        // ref.read(userProvider.notifier).getUserInfo();

        // // 로그인 상태 업데이트
        // if (context.mounted) {
        //   context.go("/register");
        // }
      } else {
        // 가입된 상태
        await secureStorage.saveAccessToken(response.accessToken);
        await secureStorage.saveRefreshToken(response.refreshToken);

        ref.read(userProvider.notifier).getUserInfo();
        final user = ref.read(userProvider);
        if (user is UserModel) {
          state = AuthModel(
            id: response.id,
            isRegistered: response.isRegistered,
            isLoggedIn: true,
          );
        }

        // // 로그인 상태 업데이트
        // if (context.mounted) {
        //   context.go("/");
        // }
      }
    } catch (e) {
      print("로그인 에러");
      print(e);

      state = null;
    }
  }

  googleLogin(BuildContext context) async {
    try {
      state = AuthModelLoading();
      final idToken = await SocialLoginRepository()
          .socialLogin(socialType: SocialType.google);

      print("idToken : $idToken");

      // if (idToken == null) {
      //   if (context.mounted) {
      //     return context.go("/login");
      //   }
      // }

      final GoogleAuthBody authReq = GoogleAuthBody(idToken: idToken![0]);

      // print("authReq: ${authReq.toJson()}");

      final response = await authRepository.postGoogleSignin(authReq);

      // 가입되어 있지 않은 상태
      if (!response.isRegistered) {
        state = AuthModel(
          id: response.id,
          isRegistered: response.isRegistered,
          isLoggedIn: false,
        );

        // ref.read(userProvider.notifier).getUserInfo();
        //  로그인 상태 업데이트
        // if (context.mounted) {
        //   context.go("/register");
        // }
      } else {
        // 가입된 상태
        await secureStorage.saveAccessToken(response.accessToken);
        await secureStorage.saveRefreshToken(response.refreshToken);

        await ref.read(userProvider.notifier).getUserInfo();
        final user = ref.read(userProvider);
        print("user");
        print(user);
        if (user is UserModel) {
          state = AuthModel(
            id: response.id,
            isRegistered: response.isRegistered,
            isLoggedIn: true,
          );
        }

        // // 로그인 상태 업데이트
        // if (context.mounted) {
        //   context.go("/");
        // }
      }
    } catch (e) {
      print("로그인 에러");
      state = null;
    }
  }
}

// @Riverpod(keepAlive: true)
// class Auth extends _$Auth {
//   late final AuthRepository authRepository = ref.read(authRepositoryProvider);
//   late final SecureStorage secureStorage = ref.read(secureStorageProvider);

//   @override
//   AuthModelBase? build() {
//     init();
//     return null;
//   }

//   /// 초기화 메서드 (await 사용 가능)
//   Future<void> init() async {
//     try {
//       await ref.read(userProvider.notifier).getUserInfo();
//       if (ref.read(userProvider) is UserModel) {
//         state = AuthModel(
//           isRegistered: true,
//           isLoggedIn: true,
//         );
//       }
//     } catch (e) {
//       state = null;
//     }
//   }

//   Future<void> register(AuthResponse response) async {
//     await secureStorage.saveAccessToken(response.accessToken);
//     await secureStorage.saveRefreshToken(response.refreshToken);
//     state = AuthModel(
//       id: response.id,
//       isRegistered: response.isRegistered,
//       isLoggedIn: false,
//     );
//   }

//   authReset() async {
//     state = null;
//     await secureStorage.storage.deleteAll();
//   }

//   resetBeforeRegister() {
//     state = null;
//   }

//   appleLogin(BuildContext context) async {
//     try {
//       state = AuthModelLoading();
//       final authInfo = await SocialLoginRepository()
//           .socialLogin(socialType: SocialType.apple);
//       if (authInfo == null) {
//         return;
//       }

//       final AppleAuthBody authReq = AppleAuthBody(
//         idToken: authInfo[0],
//         authorizationCode: authInfo[1],
//       );

//       final response = await authRepository.postAppleSignin(authReq);

//       print(response.toString());

//       // 가입되어 있지 않은 상태
//       if (!response.isRegistered) {
//         state = AuthModel(
//           id: response.id,
//           isRegistered: response.isRegistered,
//           isLoggedIn: false,
//         );

//         // ref.read(userProvider.notifier).getUserInfo();

//         // // 로그인 상태 업데이트
//         // if (context.mounted) {
//         //   context.go("/register");
//         // }
//       } else {
//         // 가입된 상태
//         await secureStorage.saveAccessToken(response.accessToken);
//         await secureStorage.saveRefreshToken(response.refreshToken);

//         ref.read(userProvider.notifier).getUserInfo();
//         final user = ref.read(userProvider);
//         if (user is UserModel) {
//           state = AuthModel(
//             id: response.id,
//             isRegistered: response.isRegistered,
//             isLoggedIn: true,
//           );
//         }

//         // // 로그인 상태 업데이트
//         // if (context.mounted) {
//         //   context.go("/");
//         // }
//       }
//     } catch (e) {
//       print("로그인 에러");
//       print(e);

//       state = null;
//     }
//   }

//   googleLogin(BuildContext context) async {
//     try {
//       state = AuthModelLoading();
//       final idToken = await SocialLoginRepository()
//           .socialLogin(socialType: SocialType.google);

//       print("idToken : $idToken");

//       // if (idToken == null) {
//       //   if (context.mounted) {
//       //     return context.go("/login");
//       //   }
//       // }

//       final GoogleAuthBody authReq = GoogleAuthBody(idToken: idToken![0]);

//       // print("authReq: ${authReq.toJson()}");

//       final response = await authRepository.postGoogleSignin(authReq);

//       // 가입되어 있지 않은 상태
//       if (!response.isRegistered) {
//         state = AuthModel(
//           id: response.id,
//           isRegistered: response.isRegistered,
//           isLoggedIn: false,
//         );

//         // ref.read(userProvider.notifier).getUserInfo();
//         //  로그인 상태 업데이트
//         // if (context.mounted) {
//         //   context.go("/register");
//         // }
//       } else {
//         // 가입된 상태
//         await secureStorage.saveAccessToken(response.accessToken);
//         await secureStorage.saveRefreshToken(response.refreshToken);

//         await ref.read(userProvider.notifier).getUserInfo();
//         final user = ref.read(userProvider);
//         print("user");
//         print(user);
//         if (user is UserModel) {
//           state = AuthModel(
//             id: response.id,
//             isRegistered: response.isRegistered,
//             isLoggedIn: true,
//           );
//         }

//         // // 로그인 상태 업데이트
//         // if (context.mounted) {
//         //   context.go("/");
//         // }
//       }
//     } catch (e) {
//       print("로그인 에러");
//       state = null;
//     }
//   }
// }
