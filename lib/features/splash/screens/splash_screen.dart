import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/auth/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (context, animation, secondAnimation) =>
                const WelcomeScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/pinterest_logo.png',
          height: 125,
        ),
      ),
    );
  }
}
