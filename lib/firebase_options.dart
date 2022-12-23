// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCjtg0kXpTYi3st6Zq19cT8zPaBeQ2U_MA',
    appId: '1:1033211481035:web:ac4eacd3041f117cc6044e',
    messagingSenderId: '1033211481035',
    projectId: 'kamallimited-7a9a5',
    authDomain: 'kamallimited-7a9a5.firebaseapp.com',
    storageBucket: 'kamallimited-7a9a5.appspot.com',
    measurementId: 'G-R1MDBSKXTG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSRvsIhQot2A0QPcHvTmqYoqei8mQIjio',
    appId: '1:1033211481035:android:871452ab84893d81c6044e',
    messagingSenderId: '1033211481035',
    projectId: 'kamallimited-7a9a5',
    storageBucket: 'kamallimited-7a9a5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFxP2g_AuwF-Fjc5udpb_iJjzexmz4ulg',
    appId: '1:1033211481035:ios:edc077fb6ee35f2ac6044e',
    messagingSenderId: '1033211481035',
    projectId: 'kamallimited-7a9a5',
    storageBucket: 'kamallimited-7a9a5.appspot.com',
    iosClientId: '1033211481035-pokv6e8i9qgh7sohigvv87odut6kkqqp.apps.googleusercontent.com',
    iosBundleId: 'com.example.kamalLimited',
  );
}