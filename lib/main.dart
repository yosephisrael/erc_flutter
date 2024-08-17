import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erbs/Users/authPage.dart';
import 'package:erbs/Users/bookSuccess.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:erbs/Users/mainScreen.dart';
import 'package:erbs/Users/registerUser.dart';
import 'package:erbs/Users/ticketExpiration.dart';
import 'package:erbs/Users/userLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
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
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(); // Ensure Firebase is initialized
//     print("Native called background task: $task");
//     await checkAndDeleteExpiredTickets();
//     return Future.value(true);
//   });
// }

Future<void> checkAndDeleteExpiredTickets() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Passengers').get();

  for (var doc in snapshot.docs) {
    Timestamp creationTime = doc['creationTime'];
    if (creationTime
        .toDate()
        .isBefore(DateTime.now().subtract(const Duration(minutes: 2)))) {
      await FirebaseFirestore.instance
          .collection('Passengers')
          .doc(doc.id)
          .delete();
      print("Deleted expired ticket with ID: ${doc.id}");
      await FirebaseFirestore.instance
          .collection('Approved Ticket Numbers')
          .doc(doc.id)
          .delete();
      print("Deleted expired ticket with ID: ${doc.id}");
      await FirebaseFirestore.instance
          .collection('TicketNumbers')
          .doc(doc.id)
          .delete();
      print("Deleted expired ticket with ID: ${doc.id}");
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true,
  // );

  // // Register the periodic task
  // Workmanager().registerPeriodicTask(
  //   "task-identifier", "simpleTask",
  //   frequency: const Duration(minutes: 15),
  //   // constraints: Constraints(
  //   //     networkType: NetworkType.connected,
  //   //     requiresBatteryNotLow: true,
  //   //     requiresCharging: true,
  //   //     requiresDeviceIdle: true,
  //   //     requiresStorageNotLow: true) // You can adjust the frequency
  // );

  await EasyLocalization.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Chapa.configure(privateKey: "CHASECK_TEST-y9q9Er1v4yQVmX4gkZX3h1vEswcXfdrz");
  TicketExpirationService ticketExpirationService = TicketExpirationService();
  ticketExpirationService.startService();

  runApp(EasyLocalization(
    supportedLocales: const [
      Locale("en", ""),
      Locale("am", ""),
    ],
    fallbackLocale: const Locale("en"),
    saveLocale: true,
    path: "assets/lang",
    child: MyApp(),
  ));
  requestPermission();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Ethiopian Railway Ticket Booking',
      theme: ThemeData(
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: const Color(0xFF3F7347), // Background color
          contentTextStyle: const TextStyle(
            color: Colors.white, // Text color
          ),
        ),
        secondaryHeaderColor: const Color(0xFF3F7347),
        primarySwatch: Colors.blue,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF3F7347),
        ),
      ),
      home: const AuthPage(),
      routes: {
        '/home': (context) => userLogin(),
        '/mainscreen': (context) => MainScreen(),
      },
    );
  }
}
