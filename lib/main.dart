import 'package:flutter/material.dart';
import 'package:open_nutri/pages/authentification/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:open_nutri/pages/authentification/login_page.dart';
import 'package:open_nutri/pages/authentification/register_page.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;

  setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  AuthPage(),
      );
  }
}







