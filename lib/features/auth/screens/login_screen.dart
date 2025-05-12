import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/utils.dart';
import 'package:pinterest_clone/features/auth/controller/auth_controller.dart';
import 'package:pinterest_clone/features/auth/widgets/login_button.dart';
import 'package:pinterest_clone/features/home/screens/home_screen.dart';
import 'package:pinterest_clone/features/tab_bar/screen/tab_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String? _email;
  String? _password;
  bool _isLoggingIn = false;
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        _formKey.currentState!.save();
        setState(() {
          _isLoggingIn = true;
        });

        bool status = await ref
            .read(authControllerProvider.notifier)
            .loginWithEmail(context, _email!, _password!);
        setState(() {
          _isLoggingIn = false;
        });
        if (status) {
          Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(pageBuilder: (_, __, ___) => const TabScreen()),
              (route) => false);
        }
      } catch (error) {
        showSnackBar(context, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        title: const Text(
          'Log in',
          style: TextStyle(
              fontFamily: 'Neue Haas Grotesk',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            LoginButton(
                'Facebook',
                const Color(0xfF3B5998),
                (context) => ref
                    .read(authControllerProvider.notifier)
                    .facebookSignIn(context)),
            const SizedBox(
              height: 5,
            ),
            LoginButton(
                'Google',
                const Color(0xff4285F4),
                (context) => ref
                    .read(authControllerProvider.notifier)
                    .googleSignIn(context)),
            const SizedBox(
              height: 5,
            ),
            LoginButton(
                'Apple',
                Colors.white,
                (context) => ref
                    .read(authControllerProvider.notifier)
                    .appleSignIn(context)),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'OR',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Neue Haas Grotesk',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.isEmpty ||
                              val.trim().isEmpty ||
                              !EmailValidator.validate(val)) {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _email = val;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: TextFormField(
                        obscureText: true,
                        validator: (val) {
                          if (val == null ||
                              val.trim().isEmpty ||
                              val.length < 8) {
                            return 'Invalid Password';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _password = val;
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .95,
                      child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                            Color(0xffE60023),
                          )),
                          onPressed: () {
                            _login();
                          },
                          child: _isLoggingIn
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
