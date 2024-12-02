import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninApi {
  static final _googleSignIn = GoogleSignIn();

  // static Future<String?> login() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await _googleSignIn.signIn();

  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount!.authentication;

  //     print(googleSignInAuthentication.accessToken);

  //     return googleSignInAuthentication.accessToken;
  //   } catch (error) {
  //     print(error);
  //   }
  //   return null;
  // }

  static void login() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        print("Sign-in cancelled by the user.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print(googleAuth.idToken);

      return;
    } catch (error) {
      print(error);
    }
    return;
  }

  // static Future<GoogleSignInAccount?> login() {
  //   return _googleSignIn.signIn();
  // };

  // static Set<Future<GoogleSignInAccount?>> login() => {_googleSignIn.signIn()};
}
