import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest_clone/core/providers/firebase_providers.dart';
import 'package:pinterest_clone/features/auth/controller/auth_controller.dart';
import 'package:pinterest_clone/features/auth/screens/welcome_screen.dart';
import 'package:pinterest_clone/features/home/screens/home_screen.dart';
import 'package:pinterest_clone/features/splash/screens/splash_screen.dart';
import 'package:pinterest_clone/features/tab_bar/screen/tab_screen.dart';
import 'package:pinterest_clone/firebase_options.dart';
import 'package:pinterest_clone/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox('user');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pinterest Clone',
        theme: ThemeData.dark(),
        home: ref.watch(authStateProvider).when(data: (user) {
          if (user == null) return const SplashScreen();

          if (ref.read(currentUserProvider.notifier).state == null) {
            Future.microtask(() {
              ref.read(authControllerProvider.notifier).loadCachedUser();
            });
          }
          return const TabScreen();
        }, error: (error, staclTrace) {
          return Scaffold(
            body: Center(
              child: Text(error.toString()),
            ),
          );
        }, loading: () {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }));
  }
}
