import 'package:erbs/Users/settings.dart';
import 'package:flutter/material.dart';
import 'package:erbs/Users/homePage.dart'; // Assuming this is your correct import path

class TermsScreen extends StatelessWidget {
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
                  'Terms and Conditions',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold,
                  ),
                ), // Adjust the width as needed
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20.0), // Outer padding
          padding: const EdgeInsets.all(20.0), // Inner padding
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
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Route Rule',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'On odd days, the available route is from Addis Ababa to Dire Dawa and stops in between. '
                  'On even days, the available route is from Dire Dawa to Addis Ababa and stops in between.\n\n',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Ticket Number Expiry',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Your ticket number expires 24 hours before the scheduled journey date, ensuring smooth and timely bookings.\n\n',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Journey Start Time',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Be punctual! Departure times are strictly adhered to for a seamless travel experience.\n\n',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Refund Policy',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Cancelled your journey? No worries! You can request a refund, though a nominal deduction of 19.84% of the paid amount will be applicable.\n\n',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Seat Selection Reservation',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Seat reservations are available exclusively for purchased tickets, ensuring fairness and convenience for all passengers.\n\n',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'No Smoking Policy',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'For the comfort and safety of all passengers, smoking is strictly prohibited onboard our trains.\n\n',
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
    );
  }
}
