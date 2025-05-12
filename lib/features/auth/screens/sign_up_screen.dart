import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/utils.dart';
import 'package:pinterest_clone/features/auth/controller/auth_controller.dart';
import 'package:pinterest_clone/features/auth/widgets/email_widget.dart';
import 'package:pinterest_clone/features/auth/widgets/password_widget.dart';
import 'package:pinterest_clone/features/tab_bar/screen/tab_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  String? _email;
  String? _password;

  void _setEmail(text) {
    setState(() {
      _email = text;
    });
  }

  void _setPassword(text) {
    setState(() {
      _password = text;
    });
  }

  void _signUp() async {
    try {
      bool status = await ref
          .read(authControllerProvider.notifier)
          .signUpWithEmail(context, _email!, _password!);
      if (status) {
        (Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (_, __, ___) => TabScreen()),
            (route) => false));
      }
    } catch (error) {
      showSnackBar(context, 'Error has occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: _email == null
            ? EmailWidget(_setEmail)
            : PasswordWidget(_setPassword, _signUp));
  }
}
