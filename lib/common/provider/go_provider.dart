import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pico/common/auth/model/auth_model.dart';
import 'package:pico/common/auth/provider/auth_provider.dart';
import 'package:pico/common/auth/provider/secure_storage.dart';
import 'package:pico/common/layout/default_layout.dart';
import 'package:pico/common/view/invite_screen.dart';
import 'package:pico/common/view/splash_screen.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';
import 'package:pico/user/view/login_screen.dart';
import 'package:pico/user/view/register_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // watch - 값이 변경될때마다 다시 빌드
  // read - 한번만 읽고 값이 변경돼도 다시 빌드하지 않음
  // final provider = ref.watch(authProvider);
  final user = ref.watch(userProvider);

  List<GoRoute> routes = [
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/',
      name: "홈",
      builder: (_, __) => DefaultLayout(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
    GoRoute(
      path: '/invite',
      name: InviteScreen.routeName,
      builder: (_, __) => InviteScreen(),
    ),
    GoRoute(
      path: '/register',
      name: RegisterScreen.routeName,
      builder: (_, __) => RegisterScreen(),
    ),
  ];

  String? redirectLogic(BuildContext context, GoRouterState goState) {
    final isLoginPage = goState.uri.toString() == '/login';
    final isSplashPage = goState.uri.toString() == '/splash';
    final isRegisterPage = goState.uri.toString() == '/register';

    print("user: $user");
    // return null;

    // 토큰이 없는 경우 혹은 토큰이 있었는데 만료한 경우
    // 다시 로그인
    if (user == null) {
      // 이미 로그인 페이지면 이동 없음. 아닌 모든 경우는 로그인 페이지로 이동
      // if (isLoginPage) {
      //   ref.read(userProvider.notifier).getUserInfo();
      //   return null;
      // } else {
      //   return isRegisterPage ? null : "/login";
      // }

      return isLoginPage
          ? null
          : isRegisterPage
              ? null
              : "/login";
    }
    // 로그인이 성공적으로 된 상태
    if (user is UserModel) {
      //로그인 페이지나 스플레시 페이지이면 홈으로 가도록 설정
      return isLoginPage || isSplashPage ? "/" : null;
    }
    return null;

    // if (user is UserModelError) {
    //   return "/login";
    // }

    // if (user is UserModel) {
    //   return isSplashPage ? "/" : null;
    // }

    // // 유저 정보가 없는 경우
    // // accessToken이나 refreshToken이 없는 경우
    // if (user == null) {
    //   // 로그인중이면 그대로 로그인 페이지에 두고
    //   // 만약에 로그인중이 아니라면 로그인 페이지로 이동
    //   if (provider is AuthModelLoading) {
    //     return logginIn ? null : '/login';
    //   }
    //   // 로그인은 시도했는데, 회원가입이 안되어 있는 경우
    //   if (provider is AuthModel) {
    //     if (provider.isRegistered == false) {
    //       return goState.uri.toString() == "/" ? "/login" : "/register";
    //     }
    //     // 회원가입까지 되었으니 로그인
    //     return "/";
    //     // return logginIn || goState.uri.toString() == '/splash' ? '/' : null;
    //   }

    //   // AuthModelError
    //   if (provider is AuthModelError) {
    //     return !logginIn ? '/login' : null;
    //   }

    //   return null;
    // }
    // return null;
  }

  return GoRouter(
    routes: routes,
    initialLocation: '/splash',
    redirect: redirectLogic,
  );
});
