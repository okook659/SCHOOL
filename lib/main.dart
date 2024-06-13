import 'package:expenses_tracker/pages/auth_page.dart';
import 'package:expenses_tracker/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDTeUcz5WSe9nZnm8v2hQwUURQeI34eb70",
          authDomain: "expenses-tracker-f104f.firebaseapp.com",
          projectId: "expenses-tracker-f104f",
          storageBucket: "expenses-tracker-f104f.appspot.com",
          messagingSenderId: "113213160525",
          appId: "1:113213160525:web:b7e0048479d08f5af67004"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
