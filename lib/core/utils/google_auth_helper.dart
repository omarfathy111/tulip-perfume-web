import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthHelper {
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // 🌐 تثبيت الجلسة محلياً لعدم تسجيل الخروج عند الـ Refresh
        await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

        // 🌐 تسجيل الدخول لمنصة الويب بـ GoogleAuthProvider المباشر
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // 📱 تسجيل الدخول لموبايل (Android / iOS)
        final GoogleSignIn googleSignIn = GoogleSignIn.instance;
        await googleSignIn.initialize();
        final GoogleSignInAccount? googleUser =
            await googleSignIn.authenticate();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return null;
    }
  }
}