import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in_android/google_sign_in_android.dart';
import 'package:google_sign_in_ios/google_sign_in_ios.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class AuthManager {
  static Future<void> signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
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

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignInPlatform.instance.signOut();
  }

  static Timer? _presenceTimer;

  static Future<void> setupPresence({required String uid}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dbRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://gigbuddy-dev-default-rtdb.europe-west1.firebasedatabase.app/',
    ).ref('presence/$uid');

    const now = ServerValue.timestamp;

    try {
      await dbRef.set({
        'state': 'online',
        'last_changed': now,
      });
      print('Set işlemi başarılı');
    } catch (e) {
      print('Hata oluştu: $e');
    }

    print('presence set');

    await dbRef.onDisconnect().set({
      'state': 'offline',
      'last_changed': now,
    });

    // Her 60 saniyede bir online durumu yenile
    _presenceTimer?.cancel(); // Önceki varsa iptal et
    _presenceTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await dbRef.update({
        'state': 'online',
        'last_changed': ServerValue.timestamp,
      });
    });
  }
}
