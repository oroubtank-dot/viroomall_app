import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBOEt_DjSwFP4eSaR5K5AaoeU-K5-w9fLM",
    authDomain: "viroomall-marketplace.firebaseapp.com",
    projectId: "viroomall-marketplace",
    storageBucket: "viroomall-marketplace.firebasestorage.app",
    messagingSenderId: "634396483295",
    appId: "1:634396483295:web:dee48ef80c5657c0cc136a",
    measurementId: "G-4P5SYKWLP7",
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return web; // مؤقتاً لحد ما نضبط المنصات التانية
  }

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: currentPlatform,
    );
  }
}
