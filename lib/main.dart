import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'add_transaction_page.dart';
import 'transaction_list_page.dart';
import 'budget_overview_page.dart';
import 'splashScreen.dart';
import 'loginPage.dart';
import 'signup.dart';
import 'home.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set the initialRoute to your splash screen
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/add_transaction': (context) => AddTransactionPage(),
        '/transaction_list': (context) => TransactionListPage(),
        '/budget_overview': (context) => BudgetOverviewPage(),
      },
    );
  }
}
