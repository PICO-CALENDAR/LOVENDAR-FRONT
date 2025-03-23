import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/common/auth/model/auth_model.dart';
import 'package:lovendar/common/auth/provider/auth_provider.dart';
import 'package:lovendar/common/components/fullscreen_loading_indicator.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  static String get routeName => 'login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final auth = ref.watch(authProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드로 인한 화면 조정 비활성화
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Logo and Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'images/lovendar_logo.png', // Replace with your actual asset path
                      width: screenWidth * 0.6, // Responsive logo size
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Lovendar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.brown[900],
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    '사랑을 기록하는 달력, \n우리의 하루를 특별하게',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  LoginButton(
                    name: 'Google 계정으로 로그인',
                    imageString: "images/google_logo.png",
                    onPressed: () {
                      ref.read(authProvider.notifier).googleLogin(context);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Platform.isIOS
                      ? SizedBox(
                          width: 300,
                          child: SignInWithAppleButton(
                            onPressed: () {
                              ref
                                  .read(authProvider.notifier)
                                  .appleLogin(context);
                            },
                            style: SignInWithAppleButtonStyle.black,
                            // 색상 지정 가능
                            height: 44,
                            // 버튼 높이 지정 가능
                            borderRadius: BorderRadius.circular(8),
                            // 아이콘 위치 지정 가능
                            text: 'Apple로 시작하기',
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 50,
                  ),
                ],
              )
            ],
          ),
          FullscreenLoadingIndicator(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLoading: auth is AuthModelLoading,
          ),
        ],
      ),
    );
  }
}

class LoginButton extends ConsumerWidget {
  final String name;
  final String imageString;
  final void Function()? onPressed;

  const LoginButton({
    super.key,
    required this.name,
    required this.imageString,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(imageString),
                height: 18.0,
                width: 24,
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 8),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
