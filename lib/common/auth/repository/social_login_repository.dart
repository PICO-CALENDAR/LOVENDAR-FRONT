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
    final googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        print("Sign-in cancelled by the user.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      return googleAuth.idToken; // idToken 반환
    } catch (error) {
      print("Error during Google Sign-In: $error");
      return null;
    }
  }
}

// 코드의 안정화를 위해 추가
abstract class SocialRepositoryImpl {
  Future<String?> socialLogin({
    required SocialType socialType,
  });
}
