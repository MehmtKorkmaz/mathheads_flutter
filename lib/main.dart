import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_mathematicians/helpers/auth_gate.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF222222)),
          cardTheme:
              const CardTheme(elevation: 0, shadowColor: Color(0xFFC2C2C2)),
          dividerColor: const Color(0xFF222222),
          textTheme: const TextTheme(
            titleMedium: TextStyle(color: Colors.white),
            titleSmall: TextStyle(color: Colors.white70),
            headlineSmall: TextStyle(fontSize: 30, color: Colors.black),
          ),
          textButtonTheme: const TextButtonThemeData(
              style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.blueGrey),
                  backgroundColor:
                      MaterialStatePropertyAll(Color(0xFF222222)))),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(color: Colors.black87, elevation: 0),
          primaryColor: Colors.blueGrey[100]),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
