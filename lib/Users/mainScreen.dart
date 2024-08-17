import 'package:erbs/Users/welcomeScreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 120,
          ),
          Image.asset(
            'images/train_image.png',
            width: 510,
            height: 300,
          ),
          const SizedBox(
            height: 80,
          ),
          const Text(
            'Explore Ethiopia with Ease',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Your ticket to seamless travel starts here',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 150,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => WelcomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F7347),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                minimumSize: const Size(330, 50)),
            child: const Text('Get Started',
                style: TextStyle(fontFamily: 'DMSans', fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
