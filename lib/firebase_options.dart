import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyD-3VWRn80GR9t7_g9wVpxWHEc_hZe6Lwo',
    appId: '1:641531430922:web:a342cd42dd4310c98ef7f3',
    messagingSenderId: '641531430922',
    databaseURL:
        'https://flutterfirebase-2c9d2-default-rtdb.europe-west1.firebasedatabase.app/',
    projectId: 'flutterfirebase-2c9d2',
    authDomain: 'flutterfirebase-2c9d2.firebaseapp.com',
    storageBucket: 'flutterfirebase-2c9d2.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvw6FUsEN_XZwci0Ll-hLcT0-G3IRdYR0',
    appId: '1:641531430922:android:2df698bd24f320638ef7f3',
    messagingSenderId: '641531430922',
    databaseURL:
        'https://flutterfirebase-2c9d2-default-rtdb.europe-west1.firebasedatabase.app/',
    projectId: 'flutterfirebase-2c9d2',
    storageBucket: 'flutterfirebase-2c9d2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXXeF8RaQgoEyBTFz5kZJI-iZcExFT9To',
    appId: '1:641531430922:ios:86a423d569156b9f8ef7f3',
    messagingSenderId: '641531430922',
    databaseURL:
        'https://flutterfirebase-2c9d2-default-rtdb.europe-west1.firebasedatabase.app/',
    projectId: 'flutterfirebase-2c9d2',
    storageBucket: 'flutterfirebase-2c9d2.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDXXeF8RaQgoEyBTFz5kZJI-iZcExFT9To',
    appId: '1:641531430922:ios:86a423d569156b9f8ef7f3',
    messagingSenderId: '641531430922',
    projectId: 'flutterfirebase-2c9d2',
    databaseURL:
        'https://flutterfirebase-2c9d2-default-rtdb.europe-west1.firebasedatabase.app/',
    storageBucket: 'flutterfirebase-2c9d2.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD-3VWRn80GR9t7_g9wVpxWHEc_hZe6Lwo',
    appId: '1:641531430922:web:24e2cb38fb6617da8ef7f3',
    messagingSenderId: '641531430922',
    projectId: 'flutterfirebase-2c9d2',
    databaseURL:
        'https://flutterfirebase-2c9d2-default-rtdb.europe-west1.firebasedatabase.app/',
    authDomain: 'flutterfirebase-2c9d2.firebaseapp.com',
    storageBucket: 'flutterfirebase-2c9d2.firebasestorage.app',
  );
}
