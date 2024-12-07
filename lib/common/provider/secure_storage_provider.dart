import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pico/common/contants/keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_provider.g.dart';

// FlutterSecureStorage
@Riverpod(keepAlive: true)
FlutterSecureStorage storage(Ref ref) {
  return const FlutterSecureStorage();
}

// 토큰 저장 등 로직을 포함한 커스텀 FlutterSecureStorage -> SecureStorage
@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  final FlutterSecureStorage storage = ref.read(storageProvider);
  return SecureStorage(storage: storage);
}

class SecureStorage {
  final FlutterSecureStorage storage;
  SecureStorage({
    required this.storage,
  });

  //  리프레시 토큰 저장
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      print('[SECURE_STORAGE] saveRefreshToken: $refreshToken');
      await storage.write(key: Keys.refreshToken, value: refreshToken);
    } catch (e) {
      print("[ERR] RefreshToken 저장 실패: $e");
    }
  }

  // 리프레시 토큰 불러오기
  Future<String?> readRefreshToken() async {
    try {
      final refreshToken = await storage.read(key: Keys.refreshToken);
      print('[SECURE_STORAGE] readRefreshToken: $refreshToken');
      return refreshToken;
    } catch (e) {
      print("[ERR] RefreshToken 불러오기 실패: $e");
      return null;
    }
  }

  // 엑세스 토큰 저장
  Future<void> saveAccessToken(String accessToken) async {
    try {
      print('[SECURE_STORAGE] saveAccessToken: $accessToken');
      await storage.write(key: Keys.accessToken, value: accessToken);
    } catch (e) {
      print("[ERR] AccessToken 저장 실패: $e");
    }
  }

  // 엑세스 토큰 불러오기
  Future<String?> readAccessToken() async {
    try {
      final accessToken = await storage.read(key: Keys.accessToken);
      print('[SECURE_STORAGE] readAccessToken: $accessToken');
      final refreshToken = await storage.read(key: Keys.refreshToken);
      print('[SECURE_STORAGE] readRefreshToken: $refreshToken');
      return accessToken;
    } catch (e) {
      print("[ERR] AccessToken 불러오기 실패: $e");
      return null;
    }
  }
}
