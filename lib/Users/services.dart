import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:erbs/Users/settings.dart'; // Assuming this is your correct import path

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Icon> _servicesIcons = [
    const Icon(
      Icons.book_outlined,
      color: Colors.white,
      size: 50,
    ), // Book Ticket
    const Icon(
      Icons.train,
      size: 50,
      color: Colors.white,
    ), // Route Rule
    const Icon(
      Icons.payment,
      size: 50,
      color: Colors.white,
    ), // Ticket Expiry
    const Icon(
      Icons.chair,
      size: 50,
      color: Colors.white,
    ), // Start Time
    const Icon(
      Icons.airline_seat_recline_normal,
      size: 50,
      color: Colors.white,
    ), // Seat Reservation
    const Icon(
      Icons.request_page,
      size: 50,
      color: Colors.white,
    ), // No Smoking Policy
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            automaticallyImplyLeading: false, // Remove default back button
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.black,
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
                  'Services',
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20.0), // Outer padding
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
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Inner padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 210,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF3F7347).withOpacity(0.5),
                          //Colors.grey.shade200.withOpacity(0.1),
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
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            for (int i = 0; i < _servicesIcons.length; i++)
                              Positioned(
                                top: 75 +
                                    70 * cos(pi / 3 * i + _animation.value),
                                left: 75 +
                                    100 * sin(pi / 3 * i + _animation.value) +
                                    60, // Adjusted position
                                child: _servicesIcons[i],
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Booking Service
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Booking Service',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '• Our user-friendly app offers a seamless and convenient booking service, allowing you to easily reserve your train tickets. ',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // One Way and Round Way Journeys
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'One Way and Round Way Journeys',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '• The Ethiopian Railway Ticket Booking App provides the flexibility to choose between one-way and round-trip journeys. ',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Seat Reservations
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Seat Reservations',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '• To enhance your travel experience, our app offers seat reservation functionality.',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // More items...
                  const SizedBox(height: 20),
                  const Text(
                    'Class Type Selection',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Experience travel tailored to your preferences with our three distinct class types:\n\n'
                    '• Hard Seat:  This class features five-row seating with comfortable chairs, providing an economical yet pleasant travel experience.\n\n'
                    '• Hard Berth: This class offers upper, middle, and lower berths, allowing you to relax and rest during your journey.\n\n'
                    '• Soft Berth: With spacious cabins and upper and lower berths, this class provides the ultimate level of comfort and sophistication.',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Online Payment Service using Chapa Payment Gateway',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '• To facilitate secure and convenient transactions, our app integrates with the Chapa Payment Gateway.',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Refund Request Service',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '• We understand that circumstances may change, and you may need to cancel your journey. \n'
                    '• Our app provides a refund request service, allowing you to initiate a refund for your ticket.\n\n',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
