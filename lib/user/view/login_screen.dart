import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/provider/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  static String get routeName => 'login';

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Logo and Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'images/pico_logo.png', // Replace with your actual asset path
                    width: screenWidth * 0.4, // Responsive logo size
                  ),
                ),
                const Text(
                  '사랑의 순간을 픽! 중요한 일정을 콕!\nPICO와 함께하는 커플 일상 공유',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                ref.read(authProvider.notifier).googleLogin(context);
              }, // Call the method directly
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("images/google_logo.png"),
                      height: 18.0,
                      width: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24, right: 8),
                      child: Text(
                        'Google 계정으로 로그인',
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
          ],
        ),
      ),
    );
  }
}
