import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/providers/firebase_providers.dart';
import 'package:pinterest_clone/features/auth/controller/auth_controller.dart';
import 'package:pinterest_clone/features/auth/screens/welcome_screen.dart';
import 'package:pinterest_clone/features/tab_bar/screen/tab_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late final Animation<double> _animation = Tween<double>(
    begin: .3,
    end: 1.0,
  ).animate(CurvedAnimation(
      parent: _animationController, curve: Curves.fastEaseInToSlowEaseOut));

  void repeatOnce() async {
    await _animationController.forward();
    await _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    repeatOnce();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(milliseconds: 1000), () {
        ref.watch(authProvider).authStateChanges().first.then((data) {
          //checks if authState changes
          if (ref.read(currentUserProvider.notifier).state == null) {
            //if authState changes, check if user state is null
            if (ref.read(authControllerProvider.notifier).isCachedUser()) {
              //check if user is cached
              Future.microtask(() {
                ref
                    .read(authControllerProvider.notifier)
                    .loadCachedUser(); //load user
              });
            }
          }
          final screen =
              data == null ? const WelcomeScreen() : const TabScreen();
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              pageBuilder: (_, __, ___) => screen,
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ScaleTransition(
        scale: _animation,
        child: Image.asset(
          'assets/images/pinterest_logo.png',
          height: 125,
        ),
      )),
    );
  }
}
