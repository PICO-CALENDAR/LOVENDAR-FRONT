import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum SocialType {
  google,
}

class SocialLoginRepository implements SocialRepositoryImpl {
  @override
  Future<String?> socialLogin({
    required SocialType socialType,
  }) async {
    switch (socialType) {
      case SocialType.google:
        return _google();
      default:
        return null;
    }
  }

  Future<String?> _google() async {
    final googleSignIn = GoogleSignIn(
      serverClientId:
          "321782365913-og9m52o0si8lfhm24opd8o2shn1tqhqr.apps.googleusercontent.com",
      // scopes: [
      //   "email",
      //   "https://www.googleapis.com/auth/userinfo.profile",
      // ],
    );
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        print("Sign-in cancelled by the user.");
        throw Exception("Sign-in cancelled by the user.");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      debugPrint("googleAuth : ${googleUser.email}");

      return googleAuth.idToken; // idToken 반환
    } catch (error) {
      print("Error during Google Sign-In: $error");
      print(error.toString());
      throw Exception("Error during Google Sign-In: $error");
    }
  }
}

// 코드의 안정화를 위해 추가
abstract class SocialRepositoryImpl {
  Future<String?> socialLogin({
    required SocialType socialType,
  });
}
