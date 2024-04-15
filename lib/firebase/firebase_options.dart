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
    apiKey: 'AIzaSyB58ZFXanfz4uG1fw_C4RS4ZkSj82zmyUg',
    appId: '1:81408523923:web:a1c7c91499d002acd79766',
    messagingSenderId: '81408523923',
    projectId: 'cameraapp-ed876',
    authDomain: 'cameraapp-ed876.firebaseapp.com',
    storageBucket: 'cameraapp-ed876.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSyPXQSTzqSRh0WcdrOYYwnt_R2XCNyKE',
    appId: '1:81408523923:android:fff0437ff4e383ccd79766',
    messagingSenderId: '81408523923',
    projectId: 'cameraapp-ed876',
    storageBucket: 'cameraapp-ed876.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3DOKhazYvvUPXpmioGg6Rx1br6TQeofU',
    appId: '1:81408523923:ios:0b130c1170f50a4dd79766',
    messagingSenderId: '81408523923',
    projectId: 'cameraapp-ed876',
    storageBucket: 'cameraapp-ed876.appspot.com',
    iosBundleId: 'com.example.testProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD3DOKhazYvvUPXpmioGg6Rx1br6TQeofU',
    appId: '1:81408523923:ios:0b130c1170f50a4dd79766',
    messagingSenderId: '81408523923',
    projectId: 'cameraapp-ed876',
    storageBucket: 'cameraapp-ed876.appspot.com',
    iosBundleId: 'com.example.testProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB58ZFXanfz4uG1fw_C4RS4ZkSj82zmyUg',
    appId: '1:81408523923:web:5eb417a3b1454581d79766',
    messagingSenderId: '81408523923',
    projectId: 'cameraapp-ed876',
    authDomain: 'cameraapp-ed876.firebaseapp.com',
    storageBucket: 'cameraapp-ed876.appspot.com',
  );
}
