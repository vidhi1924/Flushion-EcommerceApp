// File generated manually to mirror `flutterfire configure` output.
// TODO: replace the placeholder values below with the config from your
// Firebase project (Project settings > General > Your apps).
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCoRAQoQF9q4u-PIdRxAgISFK_s9hO3Ybo',
    appId: '1:642464103399:web:14a77308220ea19c095b42',
    messagingSenderId: '642464103399',
    projectId: 'flushion',
    authDomain: 'flushion.firebaseapp.com',
    storageBucket: 'flushion.firebasestorage.app',
    measurementId: 'G-5J43RXQW5L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDa3hBdmqKbij7bm7OtOeHonY1302n3D0s',
    appId: '1:642464103399:android:c16984b6e86fbc5e095b42',
    messagingSenderId: '642464103399',
    projectId: 'flushion',
    storageBucket: 'flushion.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: 'REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'REPLACE_WITH_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_STORAGE_BUCKET',
    iosBundleId: 'com.example.ecommerce',
  );
}
