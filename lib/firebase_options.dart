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
    apiKey: 'AIzaSyDwn_jJ2y-n7DyO4p4zkLxqfYKbGMrqynI',
    appId: '1:781469771810:web:43d99d7e347afa59f2827b',
    messagingSenderId: '781469771810',
    projectId: 'dmhub-ede12',
    authDomain: 'dmhub-ede12.firebaseapp.com',
    storageBucket: 'dmhub-ede12.appspot.com',
    measurementId: 'G-V00536H4XQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8sI13eLKQzF3u39e5LEKdovAnIunL9Ws',
    appId: '1:781469771810:android:99f926ace6416ee3f2827b',
    messagingSenderId: '781469771810',
    projectId: 'dmhub-ede12',
    storageBucket: 'dmhub-ede12.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOuBD3FDTdUkf9BGTXuqlgemKEpA4Zm-I',
    appId: '1:781469771810:ios:c0d2aa76ece0def1f2827b',
    messagingSenderId: '781469771810',
    projectId: 'dmhub-ede12',
    storageBucket: 'dmhub-ede12.appspot.com',
    iosBundleId: 'com.example.phomu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOuBD3FDTdUkf9BGTXuqlgemKEpA4Zm-I',
    appId: '1:781469771810:ios:c0d2aa76ece0def1f2827b',
    messagingSenderId: '781469771810',
    projectId: 'dmhub-ede12',
    storageBucket: 'dmhub-ede12.appspot.com',
    iosBundleId: 'com.example.phomu',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDwn_jJ2y-n7DyO4p4zkLxqfYKbGMrqynI',
    appId: '1:781469771810:web:19cbdaa0af3162b1f2827b',
    messagingSenderId: '781469771810',
    projectId: 'dmhub-ede12',
    authDomain: 'dmhub-ede12.firebaseapp.com',
    storageBucket: 'dmhub-ede12.appspot.com',
    measurementId: 'G-0KTZ1375S2',
  );

}