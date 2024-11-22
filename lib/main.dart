import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pico/components/common/bottom_nav.dart';
import 'package:pico/screen/splash_screen.dart';
import 'package:pico/theme/theme_light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 기기의 기본 로케일 가져오기
  final deviceLocale = PlatformDispatcher.instance.locale;
  Intl.defaultLocale = deviceLocale.toString(); // 기기 언어 설정으로 로케일 지정
  // 환경 변수 로드
  await dotenv.load(fileName: 'assets/config/.env');

  // 앱 시작
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PICO',
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      home: const BottomNav(),
      // home: const SplashScreen(),
    );
  }
}
