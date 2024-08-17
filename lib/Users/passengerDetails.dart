import 'dart:async';
import 'dart:convert';
import 'dart:math';
//import 'package:erbs/Users/notification.dart';
import 'package:erbs/Users/bookSuccess.dart';
import 'package:erbs/Users/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PassengerDetail extends StatefulWidget {
  final String startPoint;
  final String destinationPoint;
  final String startingtime;
  final String finishingtime;
  final String pricingDetail;
  final String selectedclasstype;
  final String selectejourneydate;
  final String selectedSeatLabel;
  final String Pdfrom;
  final String Pdto;

  const PassengerDetail({
    Key? key,
    required this.startPoint,
    required this.destinationPoint,
    required this.startingtime,
    required this.finishingtime,
    required this.pricingDetail,
    required this.selectedclasstype,
    required this.selectejourneydate,
    required this.selectedSeatLabel,
    required this.Pdfrom,
    required this.Pdto,
  }) : super(key: key);

  @override
  _PassengerDetailState createState() => _PassengerDetailState();
}

class _PassengerDetailState extends State<PassengerDetail> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? gender;
  final _formKey = GlobalKey<FormState>();
  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  String? mtoken = " ";
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    requestPermission();
    loadFCM();
    listenFCM();
    getTokenAndSendMessage();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                icon: '@mipmap/ic_launcher', color: const Color(0xFF3F7347)),
          ),
        );
      }
    });
  }

  void getTokenAndSendMessage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      // Check if the token already exists in Firestore
      DocumentSnapshot tokenDoc = await FirebaseFirestore.instance
          .collection('UserTokens')
          .doc(userId)
          .get();

      if (tokenDoc.exists) {
        // Token exists, retrieve it
        String token = tokenDoc.get('token');
        setState(() {
          mtoken = token;
        });
        print('Token found in Firestore: $token');
      } else {
        print('Failed to generate FCM token');
      }
    } else {
      print('User not logged in');
    }
  }

  void sendPushMessage(String title, String body, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAZscskZ0:APA91bFDcnyrvOAiJ4uxhGxbszOr7Vo-iW4UZ-Iiiki4dHRYSWV6jzCWSl7sC9bSKWz11oG8jd67ENdRxA89r-agnEQjelZ_q8_9fqBPfgoN7S6QBPf-vuLlM9fsRda_8FCeRYb_U8wW', // Replace with your actual server key
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('Push message sent');
    } catch (e) {
      print("Error sending push notification: $e");
    }
  }

  String generateTicketNumber() {
    var random = Random();
    String uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    String ticketNumber = '';
    for (int i = 0; i < 6; i++) {
      ticketNumber += uppercaseLetters[random.nextInt(26)];
    }
    return ticketNumber;
  }

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Center(
              child: Text(
                'Passenger Details',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Widgets for journey details and personal information
              // ...
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.startPoint!,
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Icon(Icons.arrow_right_alt_rounded,
                            color: Color(0xFF3F7347)),
                        Text(
                          widget.destinationPoint!,
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.shopping_bag_rounded,
                            color: Color(0xFF3F7347)),
                        const Text(
                          'Total Price :',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          widget.selectejourneydate!,
                          style: const TextStyle(
                              fontFamily: 'DMSans', fontSize: 15),
                        ),
                        const Spacer(),
                        Text(
                          'ETB ${widget.pricingDetail}',
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F7347),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                            const Text(
                              'Personal Information',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                hintText: 'First Name',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First name is required';
                                }
                                return null; // Return null if validation succeeds
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: middleNameController,
                              decoration: InputDecoration(
                                hintText: 'Middle Name',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First name is required';
                                }
                                return null; // Return null if validation succeeds
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                hintText: 'Last Name*',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First name is required';
                                }
                                return null; // Return null if validation succeeds
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Gender*',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 'Male',
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value.toString();
                                    });
                                  },
                                  activeColor: const Color(0xFF3F7347),
                                ),
                                const Text('Male'),
                                Radio(
                                  value: 'Female',
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value.toString();
                                    });
                                  },
                                  activeColor: const Color(0xFF3F7347),
                                ),
                                const Text('Female'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                            const Text(
                              'Contacts',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Email*',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                hintText: 'Phone',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (!RegExp(r'^(09|07)\d{8}$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid phone number starting with 09 or 07 and consisting of 10 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String ticketNumber = generateTicketNumber();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.train,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Ticket Information',
                                      style: TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 18,
                                          color: Colors.white)),
                                ],
                              ),
                              content: const Text(
                                  'Ticket number will expire 24 hours after Approval, '
                                  'So finish your payment before the deadline please.',
                                  style: TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 15,
                                      color: Colors.white)),
                              backgroundColor: const Color(0xFF3F7347),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side:
                                    const BorderSide(color: Color(0xFF3F7347)),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    User? user = await getCurrentUser();
                                    if (user != null) {
                                      sendMessage();
                                      addtoPassengers(ticketNumber);
                                      addTicketToFirestore(
                                          user.uid, ticketNumber);
                                      updateFirestoreAfterPayment();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              BookingSuccess(
                                            startingPoint: widget.startPoint,
                                            destinationingPoint:
                                                widget.destinationPoint,
                                            startingtiming: widget.startingtime,
                                            finishingtiming:
                                                widget.finishingtime,
                                            pricingDetailing:
                                                widget.pricingDetail,
                                            selectedclasstyping:
                                                widget.selectedclasstype,
                                            selectejourneydating:
                                                widget.selectejourneydate,
                                            uniqueticket: ticketNumber,
                                            selectedseat:
                                                widget.selectedSeatLabel,
                                            ufrom: widget.Pdfrom,
                                            uto: widget.Pdto,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('OK',
                                      style: TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 15,
                                          color: Colors.white)),
                                ),
                              ],
                            );
                          },
                        );
                        // _sendEmail(ticketNumber, emailController.text);
                        // checkAndDeleteExpiredTickets();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F7347),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 15),
                      elevation: 10,
                      minimumSize: const Size(250, 40),
                    ),
                    child: const Text('Confirm Details',
                        style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 15,
                            color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTicketToFirestore(String userId, String ticketNumber) async {
    try {
      // Create the user document with a dummy field if it doesn't exist
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection("Ticket Numbers").doc(userId);

      await userDocRef.set({
        'dummyField': 'This is a dummy field',
      }, SetOptions(merge: true));

      // Add the ticket number to the 'TN' subcollection
      await userDocRef.collection('TN').add({
        'ticketnumber': ticketNumber,
      });

      print('Ticket number $ticketNumber added for user ID $userId');
    } catch (e) {
      print('Error adding ticket number to Firestore: $e');
      // Handle error accordingly
    }
  }

  void addtoPassengers(String ticketNumber) async {
    await FirebaseFirestore.instance
        .collection('Passengers')
        .doc(ticketNumber)
        .set({
      'firstname': firstNameController.text,
      'middlename': middleNameController.text,
      'lastname': lastNameController.text,
      'gender': gender,
      'email': emailController.text,
      'phone': phoneController.text,
      'start': widget.startPoint,
      'destination': widget.destinationPoint,
      'startTime': widget.startingtime,
      'destinationTime': widget.finishingtime,
      'ticketnumber': ticketNumber,
      'classtype': widget.selectedclasstype,
      'journeydate': widget.selectejourneydate,
      'seat': widget.selectedSeatLabel,
      'price': widget.pricingDetail,
      // Add any other fields as needed
    });

    print("Document added with ID: $ticketNumber");
  }

  void sendMessage() async {
    String bodyText = 'Ticket number will expire 24 hours after Approval, '
        'So finish your payment before the deadline please.';
    QuerySnapshot tokensSnapshot =
        await FirebaseFirestore.instance.collection("UserTokens").get();

    for (var doc in tokensSnapshot.docs) {
      String token = doc['token'];
      sendPushMessage("Bookingn Confirmation", bodyText, token);
    }
  }

  Future<void> updateFirestoreAfterPayment() async {
    try {
      // Split the selected seat information
      List<String> selectedSeatInfo = widget.selectedSeatLabel.split(', ');

      // Iterate over each selected seat
      for (String seatInfo in selectedSeatInfo) {
        // Extract seat number and compartment index from seat information
        List<String> parts = seatInfo.split(' in Compartment ');
        String seatNumber = parts[0];
        int compartmentIndex = int.parse(parts[1]);

        String selectedDateYYYYMMDD = widget.selectejourneydate;
        String seatDocumentPath;

        // Determine the seatDocumentPath based on selected seat type
        if (widget.selectedclasstype == 'Hard Seat') {
          seatDocumentPath =
              'Hard Seat Selection/$selectedDateYYYYMMDD/compartments/$compartmentIndex/seats/$seatNumber';
        } else if (widget.selectedclasstype == 'Hard Berth') {
          seatDocumentPath =
              'Hard Berth Selection/$selectedDateYYYYMMDD/compartments/$compartmentIndex/seats/$seatNumber';
        } else if (widget.selectedclasstype == 'Soft Berth') {
          seatDocumentPath =
              'Soft Berth Selection/$selectedDateYYYYMMDD/compartments/$compartmentIndex/seats/$seatNumber';
        } else {
          // Handle any other type of seat here
          throw Exception('Invalid seat type');
        }

        // Update the Firestore document
        await FirebaseFirestore.instance.doc(seatDocumentPath).update({
          'isReserved': true,
        });

        print('Seat $seatNumber Reserved in Firestore.');

        // Schedule a task to reset 'isReserved' after 3 hours
        Future.delayed(Duration(hours: 2), () async {
          await FirebaseFirestore.instance.doc(seatDocumentPath).update({
            'isReserved': false,
          });
          print('Seat $seatNumber Reservation reset in Firestore.');
        });
      }
    } catch (e) {
      print('Error updating Firestore: $e');
    }
  }
}
