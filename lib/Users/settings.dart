import 'package:flutter/material.dart';
import 'package:erbs/Users/aboutUs.dart';
import 'package:erbs/Users/contactUs.dart';
import 'package:erbs/Users/services.dart';
import 'package:erbs/Users/terms.dart';
import 'package:erbs/Users/editProfile.dart';
import 'package:erbs/Users/homePage.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 65),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Insert the image here
          const SizedBox(
            height: 30,
          ),
          Center(
            child: SizedBox(
              height: 200,
              width: 250,
              child: Image.asset(
                'images/train_image.png', // Replace this with your image path
                fit: BoxFit.cover, // Ensure the image covers the entire area
              ),
            ),
          ),
          // Add some space between the image and the container
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Container(
              transform: Matrix4.translationValues(
                  0, 20, 0), // Move the container upwards
              child: Center(
                child: Container(
                  height: 360,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      // Existing content of the container
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      size: 80,
                                      color: Color(0xFF3F7347),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Account',
                                      style: TextStyle(fontFamily: 'DMSans'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Handle onTap for 'Terms and Conditions'
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermsScreen(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.description,
                                      size: 80,
                                      color: Color(0xFF3F7347),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Terms and\n'
                                      'Conditions',
                                      style: TextStyle(fontFamily: 'DMSans'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Handle onTap for 'Services'
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServiceScreen(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.build_circle,
                                      size: 80,
                                      color: Color(0xFF3F7347),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Services',
                                      style: TextStyle(fontFamily: 'DMSans'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Handle onTap for 'Developers'
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.developer_mode,
                                      size: 80,
                                      color: Color(0xFF3F7347),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Developers',
                                      style: TextStyle(fontFamily: 'DMSans'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Handle onTap for 'Services'
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutUsScreen(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      size: 80,
                                      color: Color(0xFF3F7347),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'About Us',
                                      style: TextStyle(fontFamily: 'DMSans'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Handle onTap for 'Developers'
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContactUsScreen(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 80,
                                      color: Color(0xFF3F7347),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Contact Us',
                                      style: TextStyle(fontFamily: 'DMSans'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
