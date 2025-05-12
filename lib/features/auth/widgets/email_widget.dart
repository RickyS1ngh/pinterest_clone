import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailStateProvider = StateProvider<bool>((ref) {
  return false;
});

class EmailWidget extends ConsumerStatefulWidget {
  EmailWidget(this.setEmail, {super.key});
  void Function(String) setEmail;

  @override
  ConsumerState<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends ConsumerState<EmailWidget> {
  String? _email;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
        ),
        const Text(
          'What\'s your email?',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Neue Haas Grotesk',
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                    validator: (val) {
                      if (val!.trim().isEmpty ||
                          !EmailValidator.validate(val)) {
                        Future.microtask(() {
                          ref.read(emailStateProvider.notifier).state = false;
                        });
                        return 'Invalid Email';
                      }
                      Future.microtask(() {
                        ref.read(emailStateProvider.notifier).state = true;
                      });
                      return null;
                    },
                    onSaved: (val) {
                      _email = val;
                    },
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Enter your email address',
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10)))),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .25,
                ),
                SizedBox(
                    width: 400,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                ref.watch(emailStateProvider) == true
                                    ? const WidgetStatePropertyAll(
                                        Color(0xffE60023))
                                    : WidgetStatePropertyAll(Colors.grey[800])),
                        onPressed: ref.read(emailStateProvider) == false
                            ? null
                            : () {
                                _formKey.currentState!.save();
                                widget.setEmail(_email!);
                              },
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
