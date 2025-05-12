import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/utils.dart';
import 'package:pinterest_clone/features/home/screens/home_screen.dart';
import 'package:pinterest_clone/features/splash/screens/splash_screen.dart';
import 'package:pinterest_clone/features/tab_bar/screen/tab_screen.dart';

class LoginButton extends ConsumerStatefulWidget {
  const LoginButton(this.name, this.colorButton, this.login, {super.key});
  final String name;
  final Color colorButton;
  final Future<void> Function(BuildContext) login;

  @override
  ConsumerState<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends ConsumerState<LoginButton> {
  @override
  bool _isLoading = false;
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(widget.colorButton),
          ),
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });

            await widget.login(context);

            setState(() {
              _isLoading = false;

              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                      transitionDuration: Duration(seconds: 0),
                      pageBuilder: (_, __, ___) => TabScreen()),
                  (route) => false);
            });
          },
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(
                  'Continue with ${widget.name}',
                  style: TextStyle(
                      color: widget.colorButton == Colors.white
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold),
                ),
        ));
  }
}
