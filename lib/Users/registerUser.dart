import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:erbs/Users/userLogin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _firstNameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3F7347)
                    .withOpacity(1.0), // Adjust opacity as needed
                Colors.grey.shade200, // Adjust opacity as needed
                const Color(0xFF3F7347)
                    .withOpacity(1.0), // Adjust opacity as needed
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(
                  150, 100), // Adjust the radius for the bottom-left corner
              bottomRight: Radius.circular(
                  0), // Adjust the radius for the bottom-right corner
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.2), // Shadow color with opacity
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: const Offset(0, 3), // Shadow offset
              ),
            ],
            border: Border(
              bottom: BorderSide(
                color:
                    Colors.white.withOpacity(0.3), // Border color with opacity
                width: 1, // Border width
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 15,
                right: 0,
                child: Center(
                  child: Container(
                    height: 150,
                    width: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/train_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 10),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 10),
                      child: Builder(
                        builder: (BuildContext context) {
                          return Row(
                            children: [
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: const Icon(
                              //     Icons.language,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              // GestureDetector(
                              //   onTap: () {
                              //     final RenderBox overlay = Overlay.of(context)!
                              //         .context
                              //         .findRenderObject() as RenderBox;
                              //     final RenderBox button =
                              //         context.findRenderObject() as RenderBox;
                              //     final RelativeRect position =
                              //         RelativeRect.fromSize(
                              //       Rect.fromPoints(
                              //         button.localToGlobal(
                              //             Offset(0, button.size.height + 5),
                              //             ancestor: overlay),
                              //         button.localToGlobal(
                              //             button.size.bottomRight(Offset.zero),
                              //             ancestor: overlay),
                              //       ),
                              //       overlay.size,
                              //     );
                              //     showMenu<String>(
                              //       context: context,
                              //       position: position,
                              //       items: [
                              //         const PopupMenuItem<String>(
                              //           value: 'EN',
                              //           child: Text('English',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontFamily: 'DMSans')),
                              //         ),
                              //         const PopupMenuItem<String>(
                              //           value: 'AM',
                              //           child: Text('Amharic',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontFamily: 'DMSans')),
                              //         ),
                              //         const PopupMenuItem<String>(
                              //           value: 'OR',
                              //           child: Text('Oromifa',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontFamily: 'DMSans')),
                              //         ),
                              //       ],
                              //     );
                              //   },
                              //   child: const Icon(
                              //     Icons.keyboard_arrow_down,
                              //     color: Colors.black,
                              //   ),
                              // ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Create Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: -3,
                  fontFamily: 'DMSans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              errorText: _firstNameError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(
                                      0xFF3F7347), // Change focused color to green
                                ),
                              ),
                              labelStyle: const TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email*',
                              errorText: _emailError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(
                                      0xFF3F7347), // Change focused color to green
                                ),
                              ),
                              labelStyle: const TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              hintText: 'Phone*',
                              errorText: _phoneError,
                              hintStyle: const TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(
                                      0xFF3F7347), // Change focused color to green
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password*',
                              errorText: _passwordError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(
                                      0xFF3F7347), // Change focused color to green
                                ),
                              ),
                              labelStyle: const TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password*',
                              errorText: _confirmPasswordError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(
                                      0xFF3F7347), // Change focused color to green
                                ),
                              ),
                              labelStyle: const TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Submit button
            Padding(
              padding: const EdgeInsets.all(7),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    _createAccount();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F7347),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      minimumSize: const Size(330, 50)),
                  child: const Text('Register',
                      style: TextStyle(fontFamily: 'DMSans', fontSize: 18)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addUserDetails(
      String userId, String fullname, String email, String phone) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'Full Name': fullname,
      'Email': email,
      'Phone': phone,
    });
  }

  void _createAccount() async {
    setState(() {
      _firstNameError = _firstNameController.text.isEmpty
          ? 'Please enter your full name'
          : null;
      _emailError =
          _emailController.text.isEmpty ? 'Please enter your email' : null;

      _phoneError = _passwordController.text.isEmpty
          ? 'Please enter your Phone No'
          : null;
      _passwordError = _passwordController.text.isEmpty
          ? 'Please enter your password'
          : null;
      _confirmPasswordError = _confirmPasswordController.text.isEmpty
          ? 'Please confirm your password'
          : null;
    });

    if (_firstNameController.text.trim().split(' ').length != 3) {
      setState(() {
        _firstNameError =
            'Full name must contain three names separated by spaces';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
      return;
    }

    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$')
        .hasMatch(_passwordController.text)) {
      setState(() {
        _passwordError =
            'Password must be at least 8 characters long\nand contain at least one uppercase letter,\none lowercase letter, and one number';
      });
      return;
    }

    if (!RegExp(r'^(09|07)\d{8}$').hasMatch(_phoneController.text)) {
      setState(() {
        _phoneError =
            'Enter a valid phone number starting with 09- or 07-\nFollowed by 8 digits only';
      });
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('User created: ${userCredential.user?.uid}');

      final String userId = userCredential.user!.uid;
      await addUserDetails(userId, _firstNameController.text.trim(),
          _emailController.text.trim(), _phoneController.text.trim());
      _firstNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Now You Can Log In to Your App'),
        ),
      );

      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => userLogin()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _emailError = 'This email address is already in use.';
        });
      } else {
        print('Error creating user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create account. Please try again.'),
          ),
        );
      }
    } catch (e) {
      print('Error creating user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create account. Please try again.'),
        ),
      );
    }
  }
}
