import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in_android/google_sign_in_android.dart';
import 'package:google_sign_in_ios/google_sign_in_ios.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class AuthManager {
  factory AuthManager() => _instance;

  const AuthManager._();

  static const AuthManager _instance = AuthManager._();

  static Future<void> signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<GoogleSignInUserData> signInWithGoogle() async {
    await GoogleSignInPlatform.instance.initWithParams(
      const SignInInitParameters(

        scopes: <String>[
          'email',
        ],
      ),
    );

    late final GoogleSignInPlatform googleSignIn;
    if (Platform.isIOS) {
      googleSignIn = GoogleSignInIOS();
    } else {
      googleSignIn = GoogleSignInAndroid();
    }
    final googleSignInUserData = await googleSignIn.signIn();
    if (googleSignInUserData == null) {
      throw Exception('User not signed failed with Google');
    }
    return googleSignInUserData;
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }
}
