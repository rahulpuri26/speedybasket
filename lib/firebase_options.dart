// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBdvpoKTcgfZRJGO8oCIcQC-FrQYBqGkQk',
    appId: '1:341366161560:web:d4e34844ba5ced4da350ed',
    messagingSenderId: '341366161560',
    projectId: 'speedybasket-665c0',
    authDomain: 'speedybasket-665c0.firebaseapp.com',
    storageBucket: 'speedybasket-665c0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZiFbaBuPh-vGArjJEHFo1DDdIuG3lDoU',
    appId: '1:341366161560:android:4746aaa7f3386d60a350ed',
    messagingSenderId: '341366161560',
    projectId: 'speedybasket-665c0',
    storageBucket: 'speedybasket-665c0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTQiCy4nBYKvqHdREJOnP139ug-pjNkzc',
    appId: '1:341366161560:ios:bdc37732b8e3340ea350ed',
    messagingSenderId: '341366161560',
    projectId: 'speedybasket-665c0',
    storageBucket: 'speedybasket-665c0.appspot.com',
    iosBundleId: 'com.example.speedyBasket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTQiCy4nBYKvqHdREJOnP139ug-pjNkzc',
    appId: '1:341366161560:ios:bdc37732b8e3340ea350ed',
    messagingSenderId: '341366161560',
    projectId: 'speedybasket-665c0',
    storageBucket: 'speedybasket-665c0.appspot.com',
    iosBundleId: 'com.example.speedyBasket',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBdvpoKTcgfZRJGO8oCIcQC-FrQYBqGkQk',
    appId: '1:341366161560:web:e08f0f9dac4c3f0aa350ed',
    messagingSenderId: '341366161560',
    projectId: 'speedybasket-665c0',
    authDomain: 'speedybasket-665c0.firebaseapp.com',
    storageBucket: 'speedybasket-665c0.appspot.com',
  );
}
