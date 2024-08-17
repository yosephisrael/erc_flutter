import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:erbs/Users/registerUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class userLogin extends StatefulWidget {
  @override
  _userLoginState createState() => _userLoginState();
}

class _userLoginState extends State<userLogin> {
  String selectedLanguageCode = 'EN'; // Default language code is English

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  String? mtoken = " "; // Define mtoken

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(210),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3F7347).withOpacity(1.0),
                Colors.grey.shade200,
                const Color(0xFF3F7347).withOpacity(1.0),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(150, 100),
              bottomRight: Radius.circular(0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/train_image.png'),
                      fit: BoxFit.cover,
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
                              //     final RenderBox overlay = Overlay.of(context)
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
                              //         PopupMenuItem<String>(
                              //           value: 'EN',
                              //           child: Text(
                              //             tr('english'),
                              //             style: const TextStyle(
                              //               color: Colors.black,
                              //               fontFamily: 'DMSans',
                              //             ),
                              //           ),
                              //           onTap: () => _changeLanguage('EN'),
                              //         ),
                              //         PopupMenuItem<String>(
                              //           value: 'AM',
                              //           child: Text(
                              //             tr('amharic'),
                              //             style: const TextStyle(
                              //               color: Colors.black,
                              //               fontFamily: 'DMSans',
                              //             ),
                              //           ),
                              //           onTap: () => _changeLanguage('AM'),
                              //         ),
                              //         PopupMenuItem<String>(
                              //           value: 'OM',
                              //           child: Text(
                              //             tr('oromifa'),
                              //             style: const TextStyle(
                              //               color: Colors.black,
                              //               fontFamily: 'DMSans',
                              //             ),
                              //           ),
                              //           onTap: () => _changeLanguage('OM'),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Text(
                        tr('login'),
                        style: const TextStyle(
                          height: -7,
                          fontFamily: 'DMSans',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        tr('welcomeback'),
                        style: const TextStyle(
                          height: -5,
                          fontFamily: 'DMSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: emailController,
                              cursorColor: const Color(0xFF3F7347),
                              decoration: InputDecoration(
                                labelText: tr('email'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF3F7347),
                                  ),
                                ),
                                labelStyle: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr('pleaseEnterYourEmail');
                                } else if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value.trim())) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              cursorColor: const Color(0xFF3F7347),
                              decoration: InputDecoration(
                                labelText: tr('password'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF3F7347),
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
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr('pleaseEnterYourPassword');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateAccountScreen(),
                                  ),
                                );
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Text(
                                  tr('noAccountCreateOne'),
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    decoration: TextDecoration.underline,
                                    color: Colors.yellow.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signUserIn(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F7347),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    minimumSize: const Size(300, 50),
                  ),
                  child: Text(
                    tr('login'),
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      selectedLanguageCode = languageCode;
      context.setLocale(Locale(languageCode.toLowerCase()));
    });
  }

  void signUserIn(BuildContext context) async {
    try {
      if (emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('pleaseEnterYourEmail')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      if (passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('pleaseEnterYourPassword')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Check if email exists in Firestore 'users' collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('Email', isEqualTo: emailController.text.trim())
          .get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('noAccountWithEmail')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Email found in Firestore, proceed to sign in
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final User? user = userCredential.user;
      if (user != null) {
        getToken(); // Get the token after successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('noAccountWithEmail')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('incorrectPassword')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('incorrectPassword')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error signing in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${tr('failedToSignIn')}: ${tr('unknownError')}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          mtoken = token;
        });
      }
      saveToken(token!); // Save the token
    });
  }

  void saveToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      // Delete existing token for the user if it exists
      await FirebaseFirestore.instance
          .collection("UserTokens")
          .doc(userId)
          .delete()
          .catchError((error) {
        // Handle the error if the document does not exist
        print("Error deleting existing token: $error");
      });

      // Save the new token for the user
      await FirebaseFirestore.instance
          .collection("UserTokens")
          .doc(userId)
          .set({
        'token': token,
      });
    }
  }
}
