import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/book.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:erbs/Users/payLater.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ManagePaidJourney extends StatefulWidget {
  @override
  _ManagePaidJourneyState createState() => _ManagePaidJourneyState();
}

class _ManagePaidJourneyState extends State<ManagePaidJourney> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  List<DocumentSnapshot> searchResults = [];
  bool isLoading = false;
  bool cancelButtonDisabled = false;
  String cancelButtonText = 'Cancel'; // Define cancelButtonText

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? mtoken = " ";

  @override
  void initState() {
    super.initState();
    requestPermission();
    loadFCM();
    listenFCM();
    getToken();
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
              alert: true, badge: true, sound: true);
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

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });

      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").add({
      'token': token,
    });
  }

  void sendPushMessage(String title, String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAZscskZ0:APA91bFDcnyrvOAiJ4uxhGxbszOr7Vo-iW4UZ-Iiiki4dHRYSWV6jzCWSl7sC9bSKWz11oG8jd67ENdRxA89r-agnEQjelZ_q8_9fqBPfgoN7S6QBPf-vuLlM9fsRda_8FCeRYb_U8wW',
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
            "to": mtoken,
          },
        ),
      );

      await FirebaseFirestore.instance
          .collection("UserTokens")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print("error push notification");
    }
  }

  Future<void> searchPassenger(String id) async {
    setState(() {
      searchResults.clear();
      isLoading = true;
    });

    String lowercaseId = id.toLowerCase();

    try {
      // Search in various collections
      List<String> collections = [
        'Hard Seat Passenger',
        'Hard Berth Passenger',
        'Soft Berth Passenger',
        'Round Hard Seat Passenger',
        'Round Hard Berth Passenger',
        'Round Soft Berth Passenger',
      ];

      for (String collection in collections) {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection(collection).get();

        snapshot.docs.forEach((doc) {
          String lowercaseDocId = doc.id.toLowerCase();
          if (lowercaseDocId == lowercaseId) {
            setState(() {
              searchResults.add(doc);
              isLoading = false;
            });
          }
        });
      }
      // Check if ticket number is found in 'Refund Request' collection
      QuerySnapshot refundRequestSnapshot = await FirebaseFirestore.instance
          .collection('Refund Request')
          .where(FieldPath.documentId, isEqualTo: id)
          .get();

      if (refundRequestSnapshot.docs.isNotEmpty) {
        setState(() {
          cancelButtonDisabled = true; // Disable cancel button
          cancelButtonText = 'Waiting Approval'; // Change button text
        });
      }
    } catch (e) {
      print("Error searching passengers: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submitRefundRequest(DocumentSnapshot doc) async {
    var data = doc.data() as Map<String, dynamic>;
    var fname = data['First Name'];
    var lname = data['Last Name'];
    var email = data['Email'];
    var phone = data['Phone'];
    var txRef = data['Transaction Reference'];
    var startingTime = data['Starting Timing'];
    var finishTime = data['Finishing Timing'];
    var selectedDate = data['Selected Journey Date'];
    var startPoint = data['Starting Point'];
    var destinationPoint = data['Destination Point'];
    var pricing = double.parse(data['Amount Paid']); // Parse string to double
    var classtype = data['Selected Class Type'];

    // Calculate refund amount
    double refundPercentage = 19.84;
    double refundAmount = pricing * (refundPercentage / 100);
    String refund = refundAmount.toStringAsFixed(2);

    FirebaseFirestore.instance
        .collection('Refund Request')
        .doc(searchText)
        .set({
      'First Name': fname,
      'Last Name': lname,
      'Email': email,
      'Phone': phone,
      'Starting Timing': startingTime,
      'Finishing Timing': finishTime,
      'Selected Journey Date': selectedDate,
      'Starting Point': startPoint,
      'Destination Point': destinationPoint,
      'Amount Paid': pricing,
      'Selected Class Type': classtype,
      'Transaction Reference': txRef,
    });

    setState(() {
      cancelButtonDisabled = true;
    });
    String bodyText =
        'Refund request successfully sent: Amount to be refunded: $refund .';
    QuerySnapshot tokensSnapshot =
        await FirebaseFirestore.instance.collection("UserTokens").get();

    for (var doc in tokensSnapshot.docs) {
      String token = doc['token'];
      sendPushMessage("Refund Request", bodyText);
    }
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
                  'Paid Journey',
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Enter you TN',
                hintStyle:
                    const TextStyle(fontFamily: 'DMSans', color: Colors.grey),
                prefixIcon: const Icon(Icons.key),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF3F7347), // Change focused color to green
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
                searchPassenger(value);
              },
              onSubmitted: (value) {
                searchPassenger(value);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                constraints: const BoxConstraints(
                    maxHeight: 200), // Adjust the maxHeight here
                margin: const EdgeInsets.all(20),
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
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF3F7347)),
                        ),
                      )
                    : searchResults.isEmpty
                        ? const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              var doc = searchResults[index];
                              var data = doc.data() as Map<String, dynamic>;
                              var fname = data['First Name'];
                              var lname = data['Last Name'];
                              var startingTime = data['Starting Timing'];
                              var finishTime = data['Finishing Timing'];
                              var selectedDate = data['Selected Journey Date'];
                              var startPoint = data['Starting Point'];
                              var destinationPoint = data['Destination Point'];
                              var pricing = data['Amount Paid'];
                              var classtype = data['Selected Class Type'];
                              // fetchQRCode();
// Constructing the QR code data
                              String qrCodeData = '$fname $lname\n'
                                  'Starting Time: $startingTime\n'
                                  'Finish Time: $finishTime\n'
                                  'Selected Date: $selectedDate\n'
                                  'Starting Point: $startPoint\n'
                                  'Destination Point: $destinationPoint\n'
                                  'Pricing: $pricing\n'
                                  'Class Type: $classtype';

// Function to validate Round Way Passenger's first journey
                              String validateRoundWayFirstJourney(
                                  String selectedDateTime,
                                  String selectedStartTime) {
                                DateTime selectedDate = DateFormat('E, MMM d')
                                    .parse(selectedDateTime);
                                DateTime currentDate = DateTime.now();
                                String formattedCurrentDate =
                                    DateFormat('E, MMM d').format(currentDate);
                                DateTime CurrentDate = DateFormat('E, MMM d')
                                    .parse(formattedCurrentDate);

                                if (selectedDate.isBefore(CurrentDate) ||
                                    selectedStartTime.isEmpty) {
                                  return 'Invalid';
                                } else {
                                  return 'Valid';
                                }
                              }

// Function to validate Round Way Passenger's return journey
                              String validateRoundWayReturnJourney(
                                  String returnDateTime,
                                  String returnStartTime) {
                                DateTime returnDate = DateFormat('E, MMM d')
                                    .parse(returnDateTime);
                                DateTime currentDate = DateTime.now();
                                String formattedCurrentDate =
                                    DateFormat('E, MMM d').format(currentDate);
                                DateTime CurrentDate = DateFormat('E, MMM d')
                                    .parse(formattedCurrentDate);

                                if (returnDate.isBefore(CurrentDate) ||
                                    returnStartTime.isEmpty) {
                                  print(selectedDate);
                                  print(returnStartTime);
                                  return 'Invalid';
                                } else {
                                  return 'Valid';
                                }
                              }

// Function to validate One Way Passenger
                              String validateOneWayPassenger(
                                  String selectedDateTime,
                                  String selectedStartTime) {
                                DateTime selectedDate = DateFormat('E, MMM d')
                                    .parse(selectedDateTime);
                                DateTime currentDate = DateTime.now();
                                String formattedCurrentDate =
                                    DateFormat('E, MMM d').format(currentDate);
                                DateTime CurrentDate = DateFormat('E, MMM d')
                                    .parse(formattedCurrentDate);

                                if (selectedDate.isBefore(CurrentDate) ||
                                    selectedStartTime.isEmpty) {
                                  print(selectedDate);
                                  print(selectedStartTime);
                                  return 'Invalid';
                                } else {
                                  return 'Valid';
                                }
                              }

// Check if the passenger is round trip or one way
                              if (doc.existsInRoundTripCollections()) {
                                // Fetch additional data for return journey
                                var returnData = doc.getReturnJourneyData();
                                qrCodeData +=
                                    '\nReturn Date: ${returnData['Return Date']}';
                                qrCodeData +=
                                    '\nReturn Start Point: ${returnData['Return Start Point']}';
                                qrCodeData +=
                                    '\nReturn Destination Point: ${returnData['Return Destination Point']}';
                                qrCodeData +=
                                    '\nReturn Start Time: ${returnData['Return Start Time']}';
                                qrCodeData +=
                                    '\nReturn Finish Time: ${returnData['Return Finish Time']}';
                                qrCodeData +=
                                    '\nPassenger Type: Round Way Passenger';
                                qrCodeData +=
                                    '\nFirst Journey Validation: ${validateRoundWayFirstJourney(selectedDate, startingTime)}';
                                qrCodeData +=
                                    '\nReturn Journey Validation: ${validateRoundWayReturnJourney(returnData['Return Date'], returnData['Return Start Time'])}';
                              } else {
                                qrCodeData +=
                                    '\nPassenger Type: One Way Passenger';
                                qrCodeData +=
                                    '\nValidation: ${validateOneWayPassenger(selectedDate, startingTime)}';
                              }

                              // Ensure that qrCodeData is properly formatted and encoded
                              print('QR Code Data: $qrCodeData');

                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          fname,
                                          style: const TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          lname,
                                          style: const TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Text(
                                          startingTime,
                                          style: const TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          finishTime,
                                          style: const TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Text(
                                          selectedDate,
                                          style: const TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.w100,
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          selectedDate,
                                          style: const TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.w100,
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Text(
                                          startPoint,
                                          style: const TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          color: Colors.grey,
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.train,
                                          color: Color(0xFF3F7347),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          color: Colors.grey,
                                        ),
                                        const Spacer(),
                                        Text(
                                          destinationPoint,
                                          style: const TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.chair,
                                              color: Color(0xFF3F7347),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '$classtype',
                                              style: const TextStyle(
                                                fontFamily: 'DMSans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF3F7347),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          '$pricing ETB',
                                          style: const TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color(0xFF3F7347),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 3,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: qrCodeData.isNotEmpty
                                                  ? QrImageView(
                                                      data: qrCodeData,
                                                      version: QrVersions.auto,
                                                      size: 120.0,
                                                      foregroundColor:
                                                          Colors.black,
                                                    )
                                                  : const CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ), // Show a loading indicator until data is fetched
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ElevatedButton(
                                              onPressed: cancelButtonDisabled
                                                  ? null
                                                  : () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.cancel,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  'Confirm Cancellation',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'DMSans',
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                            content: const Text(
                                                                "Are you sure you want to cancel your journey?",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'DMSans',
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white)),
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF3F7347),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 20,
                                                              vertical: 10,
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                10.0,
                                                              ),
                                                              side: const BorderSide(
                                                                  color: Color(
                                                                      0xFF3F7347)),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'DMSans',
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  submitRefundRequest(
                                                                      doc);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "OK",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'DMSans',
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.yellow.shade800,
                                                foregroundColor: Colors.black,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                elevation: 10,
                                                minimumSize:
                                                    const Size(100, 30),
                                              ),
                                              child: Text(
                                                cancelButtonDisabled
                                                    ? 'Waiting Approval'
                                                    : 'Cancel',
                                                style: const TextStyle(
                                                  fontFamily: 'DMSans',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension method to check if the document exists in round trip collections
extension DocumentExistsInRoundTripCollections on DocumentSnapshot {
  bool existsInRoundTripCollections() {
    final roundTripCollections = [
      'Round Hard Seat Passenger',
      'Round Hard Berth Passenger',
      'Round Soft Berth Passenger',
    ];
    // Check if the path of the document is contained in any of the round trip collections
    return roundTripCollections
        .any((collection) => this.reference.path.contains(collection));
  }
}

// Extension method to get return journey data
extension ReturnJourneyDataExtension on DocumentSnapshot {
  Map<String, dynamic> getReturnJourneyData() {
    if (this.exists) {
      return {
        'Return Date': this['Return Date'],
        'Return Start Point': this['Return Start Point'],
        'Return Destination Point': this['Return Destination Point'],
        'Return Start Time': this['Return Start Time'],
        'Return Finish Time': this['Return Finish Time'],
      };
    } else {
      return {};
    }
  }
}
