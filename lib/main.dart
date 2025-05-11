import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest_clone/features/auth/controller/auth_controller.dart';
import 'package:pinterest_clone/features/splash/screens/splash_screen.dart';
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
        home: StreamBuilder(
            stream: ref.watch(currentUserProvider.notifier).stream,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return const SplashScreen();
              }
              if (ref.read(authControllerProvider.notifier).isCachedUser()) {
                Future.microtask(() {
                  ref.read(authControllerProvider.notifier).loadCachedUser();
                });
              }

              return const SplashScreen();
            }));
  }
}
