import 'package:flutter/material.dart';

class CreateOptionsScreen extends StatelessWidget {
  const CreateOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            size: 30,
          ),
        ),
        title: const Text(
          'Start creating now',
          style: TextStyle(
              fontFamily: 'Neue Haas Grotesk',
              fontSize: 18,
              color: Color.fromARGB(255, 212, 208, 208)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: 75,
                        color: Colors.grey[800],
                        child: SizedBox(
                          height: 50,
                          child: Image.asset(
                            'assets/images/push_pin.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pin',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: 75,
                        color: Colors.grey[800],
                        child: SizedBox(
                          height: 50,
                          child: Image.asset(
                            'assets/images/box.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Board',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
