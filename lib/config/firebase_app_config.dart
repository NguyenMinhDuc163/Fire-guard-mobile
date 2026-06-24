import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseAppConfig {
  FirebaseAppConfig._();

  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'FirebaseAppConfig is only configured for Android and iOS.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBg5XhnyjjzUYLTIdkZxmML0ZaPeDLS6pE',
    appId: '1:820644781130:android:a08da5aa3408d69eaf1ab3',
    messagingSenderId: '820644781130',
    projectId: 'fire-guard-5a3b2',
    storageBucket: 'fire-guard-5a3b2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_0rlvF4WsF-SoV2FOhuIMNLAPufMcLFo',
    appId: '1:820644781130:ios:11b7cb85394a522daf1ab3',
    messagingSenderId: '820644781130',
    projectId: 'fire-guard-5a3b2',
    storageBucket: 'fire-guard-5a3b2.firebasestorage.app',
    iosBundleId: 'com.nguyenduc.fireGuard',
    androidClientId:
        '820644781130-hf3fdu90l4maim7ub862qget0n6j7dfe.apps.googleusercontent.com',
    iosClientId:
        '820644781130-983krlh3t7p679ah29e45qtseghm6l5j.apps.googleusercontent.com',
  );
}
