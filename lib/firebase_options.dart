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
    apiKey: 'AIzaSyCtET3SeM8SaEgj4bwx6yVGgDcEyI-Rf74',
    appId: '1:471392711052:web:725750126392b365ca26a9',
    messagingSenderId: '471392711052',
    projectId: 'marche-95a17',
    authDomain: 'marche-95a17.firebaseapp.com',
    storageBucket: 'marche-95a17.firebasestorage.app',
    measurementId: 'G-8GCS0TN6YG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAmMdzSTyGdh9M1PBUhzZFCpvfxSqMutbI',
    appId: '1:471392711052:android:c4ab6f08bd519564ca26a9',
    messagingSenderId: '471392711052',
    projectId: 'marche-95a17',
    storageBucket: 'marche-95a17.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_rOpWVUKNSmkq5QE-JI-d1oU30Bbv668',
    appId: '1:471392711052:ios:dc153823af4b16d8ca26a9',
    messagingSenderId: '471392711052',
    projectId: 'marche-95a17',
    storageBucket: 'marche-95a17.firebasestorage.app',
    iosBundleId: 'com.example.marchehaitien',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD_rOpWVUKNSmkq5QE-JI-d1oU30Bbv668',
    appId: '1:471392711052:ios:dc153823af4b16d8ca26a9',
    messagingSenderId: '471392711052',
    projectId: 'marche-95a17',
    storageBucket: 'marche-95a17.firebasestorage.app',
    iosBundleId: 'com.example.marchehaitien',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCtET3SeM8SaEgj4bwx6yVGgDcEyI-Rf74',
    appId: '1:471392711052:web:2a956f9822fc370dca26a9',
    messagingSenderId: '471392711052',
    projectId: 'marche-95a17',
    authDomain: 'marche-95a17.firebaseapp.com',
    storageBucket: 'marche-95a17.firebasestorage.app',
    measurementId: 'G-9NBG4M4Z6R',
  );
}
