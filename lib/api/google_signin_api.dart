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

  static Set<Future<GoogleSignInAccount?>> login() => {_googleSignIn.signIn()};
}
