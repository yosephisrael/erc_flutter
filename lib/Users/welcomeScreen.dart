import 'package:erbs/Users/registerUser.dart';
import 'package:erbs/Users/userLogin.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 120,
            ),
            Image.asset(
              'images/train_image.png',
              width: 420,
              height: 250,
            ),
            const SizedBox(
              height: 0,
            ),
            const Text(
              'Welcome Onboard',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Swiftly navigate Ethiopia's beauty with our ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            const Text(
              "Ethiopian Railway App - Book your journey online",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            const Text(
              "effortlessly",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 170,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => userLogin()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F7347),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  minimumSize: const Size(330, 50)),
              child: const Text('Login',
                  style: TextStyle(fontFamily: 'DMSans', fontSize: 18)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => CreateAccountScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F7347),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  minimumSize: const Size(330, 50)),
              child: const Text('Register',
                  style: TextStyle(fontFamily: 'DMSans', fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
