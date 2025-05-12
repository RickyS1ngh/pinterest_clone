import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordStateProvider = StateProvider<bool>((ref) {
  return false;
});

class PasswordWidget extends ConsumerStatefulWidget {
  PasswordWidget(this._setPassword, this._signUp, {super.key});
  final void Function(String) _setPassword;

  final void Function() _signUp;

  @override
  ConsumerState<PasswordWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends ConsumerState<PasswordWidget> {
  String? _password;
  bool showPasword = true;
  bool isSigningUp = false;
  final FocusNode _focusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
        ),
        const Text(
          'Create your pasword?',
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
                    focusNode: _focusNode,
                    validator: (val) {
                      if (val!.trim().isEmpty || val.length < 8) {
                        Future.microtask(() {
                          ref.read(passwordStateProvider.notifier).state =
                              false;
                        });
                        return 'Invalid Password';
                      }
                      Future.microtask(() {
                        ref.read(passwordStateProvider.notifier).state = true;
                      });
                      return null;
                    },
                    onSaved: (val) {
                      _password = val;
                    },
                    obscureText: showPasword,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: showPasword
                                ? () {
                                    setState(() {
                                      showPasword = false;
                                    });
                                  }
                                : () {
                                    setState(() {
                                      showPasword = true;
                                    });
                                  },
                            child: Icon(Icons.remove_red_eye_outlined)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Enter your password',
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
                                ref.watch(passwordStateProvider) == true
                                    ? const WidgetStatePropertyAll(
                                        Color(0xffE60023))
                                    : WidgetStatePropertyAll(Colors.grey[800])),
                        onPressed: ref.read(passwordStateProvider) == false
                            ? null
                            : () {
                                _formKey.currentState!.save();
                                widget._setPassword(_password!);
                                setState(() {
                                  isSigningUp = true;
                                });
                                widget._signUp();
                                setState(() {
                                  isSigningUp = false;
                                });
                              },
                        child: isSigningUp
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Sign Up',
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
