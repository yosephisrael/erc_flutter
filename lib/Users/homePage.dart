import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/book.dart';
import 'package:erbs/Users/notification.dart';
import 'package:erbs/Users/payLater.dart';
import 'package:erbs/Users/settings.dart';
import 'package:erbs/Users/updateBooked.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String? userEmail;
  final String? userPassword;

  const HomePage({Key? key, this.userEmail, this.userPassword})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _unreadNotificationsCount = 0;

  // Function to fetch the count of unread notifications
  void _fetchUnreadNotificationsCount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      QuerySnapshot unreadNotificationsSnapshot = await FirebaseFirestore
          .instance
          .collection('Notifications')
          .doc(user!.uid)
          .collection('notify')
          .where('isMarked', isEqualTo: false)
          .get();

      setState(() {
        _unreadNotificationsCount = unreadNotificationsSnapshot.size;
      });
    } catch (error) {
      print('Error fetching unread notifications count: $error');
    }
  }

// Variable to store the count of unread notifications
  final List<String> listImages = [
    'images/lubustation.png',
    'images/diredawastation.png', // Add paths for other images
    'images/adamastation.png',
    'images/vip.png',
    'images/hardseat.png',
  ];

  List<String> listTitles = [
    'Odd Day Route',
    'Even Day Route',
    'Services',
    'VIP',
    'Hard Seat Couches',
  ];

  List<String> listTexts = [
    'Addis Ababa to Dire Dawa',
    'Dire Dawa to Addis Ababa',
    'Bookings and Payment',
    'Hard Berth and Soft Berth for Comfortable Journey Experience',
    'Hard Seat couches where you can have fun with your fellows',
  ];
  late PageController _pageController;
  late Timer _timer;

  final int numberOfItems = 5; // Number of items in each list
  final int numberOfLists = 5; // Number of lists
  bool timerPaused = false; // Flag to check if timer is paused

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchUnreadNotificationsCount();

    // Start timer to auto-swipe the PageView
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients && !timerPaused) {
        // Check if timer is not paused
        if (_pageController.page == numberOfLists - 1) {
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 600), curve: Curves.ease);
        } else {
          _pageController.nextPage(
              duration: const Duration(milliseconds: 600), curve: Curves.ease);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  // Function to pause or resume the timer
  void toggleTimer() {
    setState(() {
      timerPaused = !timerPaused; // Toggle the flag
    });
  }

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  final List<String> cities = [
    'Addis Ababa',
    'Adama',
    'Bishoftu',
    'Mojo',
    'Mieso',
    'Bike',
    'Dire Dawa'
  ];

  int _selectedIndex = 0; // Define _selectedIndex variable here

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Depending on the selected index, you can navigate to different screens here
    switch (index) {
      case 0:
        // Navigate to home screen
        break;
      case 1:
        // Navigate to book ticket screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BookPage(
              from: fromController.text,
              to: toController.text,
            ),
          ),
        );
        break;
      case 2:
        // Navigate to update booking screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BottomManagePaidJourney(
              pfrom: fromController.text,
              pto: toController.text,
            ),
          ),
        );
        break;
      case 3:
        // Navigate to payment later screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => PaymentLater(
              pfrom: fromController.text,
              pto: toController.text,
            ),
          ),
        );
        break;
    }
  }

  void deleteToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("UserTokens")
          .doc(userId)
          .get();

      if (doc.exists) {
        await FirebaseFirestore.instance
            .collection("UserTokens")
            .doc(userId)
            .delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void searchJourney() {
      String fromCity = fromController.text;
      String toCity = toController.text;

      if (fromCity == toCity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Same city cannot be start and destination. Please retry.'),
            backgroundColor: Color(0xFF3F7347),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookPage(
              from: fromCity,
              to: toCity,
            ),
          ),
        );
      }
    }

    Widget buildCityListDialog(TextEditingController controller) {
      double dialogHeight = MediaQuery.of(context).size.height * 0.3;
      double itemHeight = 50.0;
      int itemCount = cities.length;
      double maxHeight = itemHeight * itemCount;
      double listViewHeight =
          dialogHeight > maxHeight ? maxHeight : dialogHeight;

      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xFF3F7347),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.4,
            height: listViewHeight + 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select City',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'DMSans',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cities.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                cities[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'DMSans',
                                  fontSize: 15.0,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  controller.text = cities[index];
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        toolbarHeight: 150,
        backgroundColor: const Color(0xFF3F7347), // Starting color
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF3F7347), // Starting color
                Colors.white, // Ending color
              ],
            ),
          ),
        ),
        title: Image.asset(
          'images/train_image.png',
          height: 180,
          width: 300,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
              ),
              if (_unreadNotificationsCount >
                  0) // Show counter only if there are unread notifications
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color:
                          Colors.yellow.shade800, // Choose your desired color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_unreadNotificationsCount',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(1),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
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
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    'images/train_image.png',
                    height: 160,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.train),
              iconColor: const Color(0xFF3F7347),
              title: const Text(
                'Recent Journeys',
                style: TextStyle(
                  fontFamily: 'DMSans',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomManagePaidJourney(
                              pfrom: fromController.text,
                              pto: toController.text,
                            )));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              iconColor: const Color(0xFF3F7347),
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontFamily: 'DMSans',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Setting()));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  iconColor: const Color(0xFF3F7347),
                  title: const Text(
                    'Log out',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Row(
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Log out',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          content: const Text(
                            'Are you sure you want to log out?',
                            style: TextStyle(
                                fontFamily: 'DMSans', color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFF3F7347),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Color(0xFF3F7347)),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.white)),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteToken();
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context)
                                    .pushReplacementNamed('/mainscreen');
                              },
                              child: const Text('OK',
                                  style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0), // Add padding here
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // const SizedBox(
              //   height: 1,
              // ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book a Journey',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Make your Journey Memorable!',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 175,
                width: MediaQuery.of(context).size.width,
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    buildCityListDialog(fromController),
                              );
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: fromController,
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: 'DMSans'),
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF3F7347)),
                                  ),
                                  hintText: 'From',
                                  hintStyle: const TextStyle(fontSize: 15),
                                  prefixIcon: const Icon(Icons.train,
                                      color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF3F7347)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz),
                          onPressed: () {
                            String temp = fromController.text;
                            fromController.text = toController.text;
                            toController.text = temp;
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    buildCityListDialog(toController),
                              );
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: toController,
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: 'DMSans'),
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF3F7347)),
                                  ),
                                  hintText: 'To',
                                  prefixIcon: const Icon(Icons.train,
                                      color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF3F7347)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: searchJourney,
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: const Color(0xFF3F7347),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        minimumSize: const Size(280, 30),
                      ),
                      child: const Text('Search Journey',
                          style: TextStyle(fontSize: 16, fontFamily: 'DMSans')),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              // Horizontally scrollable list of containers
              Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3F7347).withOpacity(0.9),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: numberOfLists,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 0.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  child: Image.asset(
                                    listImages[index],
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    color: Colors.black.withOpacity(0.3),
                                    colorBlendMode: BlendMode.darken,
                                  ),
                                ),
                                ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: numberOfItems,
                                  itemBuilder:
                                      (BuildContext context, int itemIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        width: 385,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            listTexts[index],
                                            style: const TextStyle(
                                              fontFamily: 'DMSans',
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Text(
                                    listTitles[
                                        index], // Use different title for each list
                                    style: const TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey.shade200,
          selectedItemColor: const Color(0xFF3F7347),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          selectedLabelStyle: const TextStyle(fontFamily: 'DMSans'),
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.train),
              label: 'Book',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.luggage),
              label: 'Journey',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Payment',
            ),
          ],
        ),
      ),
    );
  }
}
