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
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCsGGmmTj0jHoIUKb3BpyfLWMhtIk5oaFg',
    appId: '1:829147882423:android:c05216ce55de7a26f4fe32',
    messagingSenderId: '829147882423',
    projectId: 'smart-bin-v2',
    authDomain: 'smart-bin-v2.firebaseapp.com',
    storageBucket: 'smart-bin-v2.firebasestorage.app',
    databaseURL:
        'https://smart-bin-v2-default-rtdb.europe-west1.firebasedatabase.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsGGmmTj0jHoIUKb3BpyfLWMhtIk5oaFg',
    appId: '1:829147882423:android:c05216ce55de7a26f4fe32',
    messagingSenderId: '829147882423',
    projectId: 'smart-bin-v2',
    storageBucket: 'smart-bin-v2.firebasestorage.app',
    databaseURL:
        'https://smart-bin-v2-default-rtdb.europe-west1.firebasedatabase.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsGGmmTj0jHoIUKb3BpyfLWMhtIk5oaFg',
    appId: '1:829147882423:android:c05216ce55de7a26f4fe32',
    messagingSenderId: '829147882423',
    projectId: 'smart-bin-v2',
    storageBucket: 'smart-bin-v2.firebasestorage.app',
    databaseURL:
        'https://smart-bin-v2-default-rtdb.europe-west1.firebasedatabase.app',
    iosBundleId: 'com.example.trashCan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCsGGmmTj0jHoIUKb3BpyfLWMhtIk5oaFg',
    appId: '1:829147882423:android:c05216ce55de7a26f4fe32',
    messagingSenderId: '829147882423',
    projectId: 'smart-bin-v2',
    storageBucket: 'smart-bin-v2.firebasestorage.app',
    databaseURL:
        'https://smart-bin-v2-default-rtdb.europe-west1.firebasedatabase.app',
    iosBundleId: 'com.example.trashCan',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCsGGmmTj0jHoIUKb3BpyfLWMhtIk5oaFg',
    appId: '1:829147882423:android:c05216ce55de7a26f4fe32',
    messagingSenderId: '829147882423',
    projectId: 'smart-bin-v2',
    storageBucket: 'smart-bin-v2.firebasestorage.app',
    databaseURL:
        'https://smart-bin-v2-default-rtdb.europe-west1.firebasedatabase.app',
  );
}
