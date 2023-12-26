import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AuthenticationScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyCGMJ2LTZLctYQTUJXVcmr9g5LeVSlrC7o',
      //authDomain: 'your_auth_domain',
      projectId: 'flutter-project-1093',
      //storageBucket: 'your_storage_bucket',
      messagingSenderId: '970914061478',
      appId: '1:970914061478:android:69f65d1652006dc266e867',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthenticationScreen(),
    );
  }
}
