import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/auth/screens/welcome_screen.dart';
import 'package:pinterest_clone/features/splash/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pinterest Clone',
        theme: ThemeData.dark(),
        home: SplashScreen());
  }
}
