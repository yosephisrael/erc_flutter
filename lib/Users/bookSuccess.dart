import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:erbs/Users/payLater.dart';
import 'package:flutter/material.dart';

class BookingSuccess extends StatefulWidget {
  final String startingPoint;
  final String destinationingPoint;
  final String startingtiming;
  final String finishingtiming;
  final String pricingDetailing;
  final String selectedclasstyping;
  final String selectejourneydating;
  final String uniqueticket;
  final String selectedseat;
  final String ufrom;
  final String uto;

  const BookingSuccess({
    Key? key,
    required this.startingPoint,
    required this.destinationingPoint,
    required this.startingtiming,
    required this.finishingtiming,
    required this.pricingDetailing,
    required this.selectedclasstyping,
    required this.selectejourneydating,
    required this.uniqueticket,
    required this.selectedseat,
    required this.ufrom,
    required this.uto,
  }) : super(key: key);

  @override
  State<BookingSuccess> createState() => _BookingSuccessState();
}

class _BookingSuccessState extends State<BookingSuccess> {
  String fname = '';
  String lname = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    initializeStrings();
  }

  Future<void> initializeStrings() async {
    try {
      var passengerSnapshot = await FirebaseFirestore.instance
          .collection('Passengers')
          .where('ticketnumber', isEqualTo: widget.uniqueticket)
          .limit(1)
          .get();

      if (passengerSnapshot.docs.isNotEmpty) {
        var passengerData = passengerSnapshot.docs.first.data();
        setState(() {
          fname = passengerData['firstname'];
          lname = passengerData['lastname'];
          email = passengerData['email'];
          phone = passengerData['phone'];
        });
      } else {
        print(
            'No passenger data found for ticket number: ${widget.uniqueticket}');
      }
    } catch (e) {
      print('Error fetching passenger information: $e');
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    String price = widget.pricingDetailing;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Stack(
            children: [
              const SizedBox(height: 200),
              Column(
                children: [
                  Container(
                    height: 590,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 50),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      fname,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w100,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      lname,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w100,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w100,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      phone,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w100,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 1,
                                  width: MediaQuery.of(context).size.width / 1,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      widget.startingtiming,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.finishingtiming,
                                      style: const TextStyle(
                                        color: Colors.white,
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
                                      widget.selectejourneydating,
                                      style: const TextStyle(
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.selectejourneydating,
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
                                      widget.startingPoint,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      color: Colors.grey,
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.train,
                                      color: Colors.white,
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      color: Colors.grey,
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.destinationingPoint,
                                      style: const TextStyle(
                                        color: Colors.white,
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
                                    Text(
                                      '$price ETB',
                                      style: const TextStyle(
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Per Passenger',
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Positioned.fill(
                top: 390,
                bottom: 50,
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: Color(0xFF3F7347),
                              size: 100,
                            ),
                            SizedBox(width: 5),
                            Center(
                              child: Text(
                                'Journey Booked Successfully!',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PaymentLater(
                                    pfrom: widget.ufrom,
                                    pto: widget.uto,
                                  ),
                                ),
                              );
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
                              'Continue To Payment',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'Ticket number will expire after 24 hours, '
                            'So finish your payment before the deadline please.',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'DMSans'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
}
