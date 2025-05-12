import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/auth/screens/login_screen.dart';
import 'package:pinterest_clone/features/auth/screens/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late Image _colosseumImage;
  late Image _pizzaImage;
  late Image _roomImage;
  late Image _pinterestLogo;
  String? welcomeText1;
  String? welcomeText2;
  late AnimationController _animationController; //controls timing
  late final Animation<double> _breathingAnimation = //actual animation
      Tween<double>(begin: 1, end: 1.05).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut));

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _colosseumImage = Image.asset(
      'assets/images/colosseum_image.jpg',
      height: 300,
      width: 300,
      fit: BoxFit.cover,
    );
    _pizzaImage = Image.asset(
      'assets/images/pizza_image.jpg',
      height: 200,
    );
    _roomImage = Image.asset(
      'assets/images/room_image.jpg',
      height: 300,
      width: 200,
      fit: BoxFit.cover,
    );
    _pinterestLogo = Image.asset(
      'assets/images/pinterest_logo.png',
      height: 50,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        welcomeText1 = 'Create the life you';
      });
    });
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        welcomeText2 = 'love on Pinterest';
      });
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(_colosseumImage.image, context);
    precacheImage(_pizzaImage.image, context);
    precacheImage(_roomImage.image, context);
    precacheImage(_pinterestLogo.image, context);
  }

  void _login() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height * .95,
        child: const LoginScreen(),
      ),
    );
  }

  void _signUp() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => const SizedBox(
              child: SignUpScreen(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: ScaleTransition(
            scale: _breathingAnimation,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10), child: _pizzaImage),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: ScaleTransition(
            scale: _breathingAnimation,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10), child: _roomImage),
          ),
        ),
        Align(
          alignment: const Alignment(0, -.3),
          child: ScaleTransition(
              scale: _breathingAnimation,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _colosseumImage)),
        ),
        Align(alignment: const Alignment(0, .3), child: _pinterestLogo),
        Align(
          alignment: const Alignment(0, .5),
          child: Text(welcomeText1 == null ? '' : welcomeText1!,
              style: const TextStyle(
                  fontFamily: 'Neue Haas Grotesk', fontSize: 40)),
        ),
        Align(
          alignment: const Alignment(0, .6),
          child: Text(
            welcomeText2 == null ? '' : welcomeText2!,
            style:
                const TextStyle(fontFamily: 'Neue Haas Grotesk', fontSize: 40),
          ),
        ),
        Align(
            alignment: const Alignment(0, .7),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * .04,
                width: MediaQuery.of(context).size.width * .8,
                child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xffE60023),
                      ),
                    ),
                    onPressed: () {
                      _signUp();
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    )))),
        Align(
          alignment: const Alignment(0, .8),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .04,
            width: MediaQuery.of(context).size.width * .8,
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.grey)),
              onPressed: () {
                _login();
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
