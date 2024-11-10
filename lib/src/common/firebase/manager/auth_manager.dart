import 'package:firebase_auth/firebase_auth.dart';

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

  static Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }
}
