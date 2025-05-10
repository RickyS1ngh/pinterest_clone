import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            Navigator.of(context).popUntil((route) => route.isFirst);
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
