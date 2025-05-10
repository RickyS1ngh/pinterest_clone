import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton(this.name, this.colorButton, {super.key});
  final String name;
  final Color colorButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(colorButton),
          ),
          onPressed: () {},
          child: Text(
            'Continue with $name',
            style: TextStyle(
                color:
                    colorButton == Colors.white ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ));
  }
}
