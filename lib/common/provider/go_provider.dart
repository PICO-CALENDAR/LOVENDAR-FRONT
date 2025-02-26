import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lovendar/common/auth/model/auth_model.dart';
import 'package:lovendar/common/auth/provider/auth_provider.dart';

import 'package:lovendar/common/components/network_aware_widget.dart';
import 'package:lovendar/common/layout/default_layout.dart';

import 'package:lovendar/common/view/edit_schedule_screen.dart';
import 'package:lovendar/common/view/invite_screen.dart';
import 'package:lovendar/common/view/splash_screen.dart';

import 'package:lovendar/user/view/login_screen.dart';
import 'package:lovendar/user/view/mypage/mypage_screen.dart';
import 'package:lovendar/user/view/register_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // watch - 값이 변경될때마다 다시 빌드
  // read - 한번만 읽고 값이 변경돼도 다시 빌드하지 않음
  // final provider = ref.watch(authProvider);
  // final user = ref.watch(userProvider);
  final auth = ref.watch(authProvider);

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
      path: '/editSchedule',
      name: EditScheduleScreen.routeName,
      builder: (_, __) => EditScheduleScreen(),
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
    GoRoute(
      path: '/mypage',
      name: MypageScreen.routeName,
      builder: (_, __) => MypageScreen(),
    ),
  ];

  String? redirectLogic(BuildContext context, GoRouterState goState) {
    final isLoginPage = goState.uri.toString() == '/login';
    final isSplashPage = goState.uri.toString() == '/splash';
    // final isRegisterPage = goState.uri.toString() == '/register';

    // print("router interenet : $result");
    if (auth is AuthModelInitial) {
      return isLoginPage ? null : "/splash";
    }

    // 토큰이 없는 경우 혹은 토큰이 있었는데 만료한 경우
    // 다시 로그인
    if (auth == null || auth is AuthModelLoading) {
      return isLoginPage ? null : "/login";

      // return isLoginPage
      //     ? null
      //     : isRegisterPage
      //         ? null
      //         : "/login";
    }

    // 로그인이 성공적으로 된 상태
    if (auth is AuthModel) {
      if (!auth.isRegistered) {
        // 가입이 안된 상태
        return "/register";
      } else {
        // 가입이 된 상태
        return (isLoginPage || isSplashPage) ? "/" : null;
      }
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
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return NetworkAwareWidget(child: child); // 공통 부모 레이아웃
        },
        routes: routes,
      ),
    ],
    initialLocation: '/splash',
    redirect: redirectLogic,
  );
});
