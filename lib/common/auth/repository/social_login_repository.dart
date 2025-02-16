import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum SocialType { google, apple }

class SocialLoginRepository implements SocialRepositoryImpl {
  @override
  Future<List<String>?> socialLogin({
    required SocialType socialType,
  }) async {
    switch (socialType) {
      case SocialType.google:
        return _google();
      case SocialType.apple:
        return _apple();
      default:
        return null;
    }
  }

  Future<List<String>?> _apple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("name ${appleCredential.familyName}");

      // authorizationCode
      final String authorizationCode = appleCredential.authorizationCode;

      // idToken
      final String? idToken = appleCredential.identityToken;

      if (authorizationCode.isEmpty || idToken == null) {
        return null;
      }

      return [idToken, authorizationCode];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<String>?> _google() async {
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

      if (googleAuth.idToken == null) {
        return null;
      }

      return [googleAuth.idToken!]; // idToken 반환
    } catch (error) {
      print("Error during Google Sign-In: $error");
      print(error.toString());
      throw Exception("Error during Google Sign-In: $error");
    }
  }
}

// 코드의 안정화를 위해 추가
abstract class SocialRepositoryImpl {
  Future<List<String>?> socialLogin({
    required SocialType socialType,
  });
}
