import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/components/network_aware_widget.dart';
import 'package:pico/common/provider/go_provider.dart';
import 'package:pico/common/theme/theme_light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 기기의 기본 로케일 가져오기
  final deviceLocale = PlatformDispatcher.instance.locale;
  Intl.defaultLocale = deviceLocale.toString(); // 기기 언어 설정으로 로케일 지정

  // 환경 변수 로드
  await dotenv.load(fileName: 'assets/config/.env');

  // 앱 시작
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'PICO',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // routes: {
      //   '/': (context) => const BottomNav(),
      //   '/login': (context) => const LoginScreen(),
      //   '/register': (context) => const RegisterScreen(),
      // },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
    );
  }
}
