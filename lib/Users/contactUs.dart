import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:erbs/Users/settings.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            backgroundColor: const Color(0xFF3F7347),
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => Setting(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                const Text(
                  'Contact Us',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 290,
                  width: 450,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F7347),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.elliptical(150, 60),
                      bottomRight: Radius.elliptical(150, 60),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '+251-11-1234567 ',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'ercad@gmail.com',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Positioned.fill(
              top: 150,
              bottom: 100,
              left: 10,
              right: 10,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(20.0),
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
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.message_rounded,
                              color: Colors.black,
                              size: 60,
                            ),
                            SizedBox(width: 5),
                            Center(
                              child: Text(
                                'Feel Free To Drop as a Message',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email*',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.white,
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
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 190,
                          child: SingleChildScrollView(
                            child: TextFormField(
                              controller: _messageController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Message is required';
                                } else if (value.trim().split(' ').length >
                                    10) {
                                  return 'Message should contain at most 10 words';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Type your message here...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
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
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submitForm();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F7347),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              minimumSize: const Size(50, 20),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    try {
      // Access the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Access Firestore and save data with auto-generated ID under 'Contacts' collection
      CollectionReference contactsCollection =
          FirebaseFirestore.instance.collection('Contacts');

      // Add the email, message, and uid to the collection
      await contactsCollection.add({
        'email': _emailController.text,
        'message': _messageController.text,
        'uid': user!.uid,
      });

      // Clear the text fields after submission
      _emailController.clear();
      _messageController.clear();

      // Show a success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully')),
      );
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error submitting form: $error');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred, please try again later')),
      );
    }
  }
}
