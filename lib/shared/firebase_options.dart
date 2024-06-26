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
        return macos;
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
    apiKey: 'AIzaSyCwLhBz6_hM5NK0Elb6X73wldjU5MhGzyA',
    appId: '1:1019251402010:web:3076e199536e8bb85d38a3',
    messagingSenderId: '1019251402010',
    projectId: 'pv292-chatting-app-8ed91',
    authDomain: 'pv292-chatting-app-8ed91.firebaseapp.com',
    storageBucket: 'pv292-chatting-app-8ed91.appspot.com',
    measurementId: 'G-6WTHSTQZEX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEOuW4rq8ovZjIyNUDZp81UvW9_ByvJls',
    appId: '1:1019251402010:android:a634eef92326a3d45d38a3',
    messagingSenderId: '1019251402010',
    projectId: 'pv292-chatting-app-8ed91',
    storageBucket: 'pv292-chatting-app-8ed91.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQUb0gx6fD6NQ8wx01GxyefDQxT2IH3KU',
    appId: '1:1019251402010:ios:f30f231c8cc0aff45d38a3',
    messagingSenderId: '1019251402010',
    projectId: 'pv292-chatting-app-8ed91',
    storageBucket: 'pv292-chatting-app-8ed91.appspot.com',
    iosBundleId: 'cz.muni.fi.pv292.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCQUb0gx6fD6NQ8wx01GxyefDQxT2IH3KU',
    appId: '1:1019251402010:ios:195a0736327c887d5d38a3',
    messagingSenderId: '1019251402010',
    projectId: 'pv292-chatting-app-8ed91',
    storageBucket: 'pv292-chatting-app-8ed91.appspot.com',
    iosBundleId: 'cz.muni.fi.pv292.chatApp.RunnerTests',
  );
}
