import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/book.dart';
import 'package:erbs/Users/finalQR.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:erbs/Users/passengerDetails.dart';
import 'package:erbs/Users/roundFinalQR.dart';
import 'package:erbs/Users/updateBooked.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';

class PaymentLater extends StatefulWidget {
  final String pfrom;
  final String pto;
  const PaymentLater({super.key, required this.pfrom, required this.pto});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentLater> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false; // Track button enabled state
  TextEditingController ticketNumberController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  bool isPaymentButtonEnabled = false; // Define isPaymentButtonEnabled variable

  bool isloading = false;

  int _selectedIndex = 3; // Define _selectedIndex variable here

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Depending on the selected index, you can navigate to different screens here
    switch (index) {
      case 0:
        // Navigate to home screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
        break;
      case 1:
        // Navigate to book ticket screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BookPage(
              from: widget.pfrom,
              to: widget.pto,
            ),
          ),
        );
        break;
      case 2:
        // Navigate to update booking screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BottomManagePaidJourney(
              pfrom: widget.pfrom,
              pto: widget.pto,
            ),
          ),
        );
        break;
      case 3:
        // Navigate to payment later screen
        break;
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const HomePage(),
                ));
              },
            ),
            title: const Center(
              child: Text(
                'Payment',
                style: TextStyle(fontWeight: FontWeight.bold),
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
              const SizedBox(height: 15),
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
                              'Payment Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: ticketNumberController,
                              decoration: InputDecoration(
                                hintText: 'Ticket Number*',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF3F7347)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(
                                          0xFF3F7347)), // Use the same color as focused border
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorStyle: const TextStyle(color: Colors.red),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  isButtonEnabled = value.isNotEmpty;
                                });
                              },
                              validator: _validateTicketNumber,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: fnameController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'First Name*',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF3F7347)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: lnameController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Last Name*',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF3F7347)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: emailController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Email*',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF3F7347)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Phone No*',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF3F7347)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: amountController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Amount',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF3F7347)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  // Call method to fetch data from Firestore
                                  await _fetchPassengerData();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F7347),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          elevation: 10,
                          minimumSize: const Size(100, 40),
                        ),
                        child: const Text('Confirm TN',
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 15,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: isPaymentButtonEnabled
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  String TxRef = _generateRandomNumber();
                                  await _pay(context, TxRef);
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F7347),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          elevation: 10,
                          minimumSize: const Size(100, 40),
                        ),
                        child: const Text('Continue to Payment',
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 15,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20.0), // Adjust the value as needed
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Ensure all icons are visible
          backgroundColor: Colors.grey.shade200, // Set background color
          selectedItemColor: const Color(0xFF3F7347), // Set selected item color
          unselectedItemColor: Colors.grey, // Set unselected item color
          currentIndex: _selectedIndex, // Current selected index
          onTap: _onItemTapped, // Handle item tap
          selectedLabelStyle: const TextStyle(fontFamily: 'DMSans'),
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

  Future<void> _pay(BuildContext context, String TxRef) async {
    try {
      await Chapa.getInstance.startPayment(
        context: context,
        onInAppPaymentSuccess: (successMsg) async {
          setState(() {
            isloading = true;
          });
          // Navigate to FinalQR if data found in Passengers collection
          // Check if the data exists in Round Passengers collection
          var oneDocSnapshot = await FirebaseFirestore.instance
              .collection('Passengers')
              .doc(ticketNumberController.text)
              .get();

          // Check if the data exists in Round Passengers collection
          var roundDocSnapshot = await FirebaseFirestore.instance
              .collection('Round Passengers')
              .doc(ticketNumberController.text)
              .get();
          if (oneDocSnapshot.exists) {
            String firstName = oneDocSnapshot['firstname'];
            String lastName = oneDocSnapshot['lastname'];
            String emailAdd = oneDocSnapshot['email'];
            String phoneNo = oneDocSnapshot['phone'];
            String startPoint = oneDocSnapshot['start'];
            String destPoint = oneDocSnapshot['destination'];
            String stTime = oneDocSnapshot['startTime'];
            String finTime = oneDocSnapshot['destinationTime'];
            String classtypes = oneDocSnapshot['classtype'];
            String datetypes = oneDocSnapshot['journeydate'];
            String seattypes = oneDocSnapshot['seat'];
            // If data exists, navigate to RoundFinalQR page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => finalQR(
                  // Pass necessary parameters to RoundFinalQR constructor
                  fname: firstName,
                  lname: lastName,
                  email: emailAdd,
                  phone: phoneNo,
                  stPoint: startPoint,
                  destPoint: destPoint,
                  sttime: stTime,
                  fintime: finTime,
                  priDetai: amountController.text,
                  uniqueTicket: ticketNumberController.text,
                  selclass: classtypes,
                  seldate: datetypes,
                  selseat: seattypes,
                  txRef: TxRef,
                ),
              ),
            );
          } else if (roundDocSnapshot.exists) {
            String firstName = roundDocSnapshot['firstname'];
            String lastName = roundDocSnapshot['lastname'];
            String emailAdd = roundDocSnapshot['email'];
            String phoneNo = roundDocSnapshot['phone'];
            String startPoint = roundDocSnapshot['start'];
            String destPoint = roundDocSnapshot['destination'];
            String stTime = roundDocSnapshot['startTime'];
            String finTime = roundDocSnapshot['destinationTime'];
            String classtypes = roundDocSnapshot['classtype'];
            String datetypes = roundDocSnapshot['journeydate'];
            String seattypes = roundDocSnapshot['seat'];

            String returnDate = roundDocSnapshot['returndate'];
            String returnStartPoint = roundDocSnapshot['returnstartpoint'];
            String returnDestinationPoint =
                roundDocSnapshot['returndestinationpoint'];
            String returnStartTime = roundDocSnapshot['returnstarttime'];
            String returnFinishTime = roundDocSnapshot['returnfinishtime'];
            // If data exists, navigate to RoundFinalQR page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoundfinalQR(
                  // Pass necessary parameters to RoundFinalQR constructor
                  fname: firstName,
                  lname: lastName,
                  email: emailAdd,
                  phone: phoneNo,
                  stPoint: startPoint,
                  destPoint: destPoint,
                  sttime: stTime,
                  fintime: finTime,
                  priDetai: amountController.text,
                  uniqueTicket: ticketNumberController.text,
                  selclass: classtypes,
                  seldate: datetypes,
                  selseat: seattypes,
                  txRef: TxRef,
                  returnstartingPoint: returnStartPoint,
                  returndestinationingPoint: returnDestinationPoint,
                  returnStartingtime: returnStartTime,
                  returnFinishingtime: returnFinishTime,
                  selectedReturningDate: returnDate,
                ),
              ),
            );
          }
        },
        onInAppPaymentError: (errorMsg) {
          // Handle error
        },
        amount: amountController.text, //required parameter
        currency: 'ETB',
        txRef: TxRef, //required parameter
        email: emailController.text,
        firstName: fnameController.text,
        lastName: lnameController.text,
        title: 'Ticket Purchase',
        phoneNumber: phoneController.text,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  String _generateRandomNumber() {
    String prefix = 'ERC-';
    int randomNumber = Random().nextInt(100000);
    String formattedNumber = randomNumber.toString().padLeft(5, '0');
    String result = '$prefix$formattedNumber';
    return result;
  }

  String? _validateTicketNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ticket number is required';
    }

    RegExp ticketNumberPattern = RegExp(r'^[A-Z]{6}$');

    if (!ticketNumberPattern.hasMatch(value)) {
      return 'Invalid ticket number format';
    }

    return null; // Return null if the validation succeeds
  }

  Future<void> _fetchPassengerData() async {
    try {
      // Fetch data from 'Passengers' Firestore collection based on ticket number
      var passengerDocSnapshot = await FirebaseFirestore.instance
          .collection('Passengers')
          .doc(ticketNumberController.text)
          .get();

      // Fetch data from 'Round Passengers' Firestore collection based on ticket number
      var roundPassengerDocSnapshot = await FirebaseFirestore.instance
          .collection('Round Passengers')
          .doc(ticketNumberController.text)
          .get();

      // Check if either of the documents exists
      if (passengerDocSnapshot.exists) {
        var passengerData = passengerDocSnapshot.data();

        // Populate text fields with retrieved data from 'Passengers' collection
        setState(() {
          fnameController.text = passengerData!['firstname'] ?? '';
          lnameController.text = passengerData['lastname'] ?? '';
          emailController.text = passengerData['email'] ?? '';
          phoneController.text = passengerData['phone'] ?? '';
          amountController.text = passengerData['price'] ?? '';
        });
      } else if (roundPassengerDocSnapshot.exists) {
        var roundPassengerData = roundPassengerDocSnapshot.data();

        // Populate text fields with retrieved data from 'Round Passengers' collection
        setState(() {
          fnameController.text = roundPassengerData!['firstname'] ?? '';
          lnameController.text = roundPassengerData['lastname'] ?? '';
          emailController.text = roundPassengerData['email'] ?? '';
          phoneController.text = roundPassengerData['phone'] ?? '';
          amountController.text = roundPassengerData['price'] ?? '';
        });
      } else {
        // Handle case where no matching document is found in either collection
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Passenger data not found for the entered ticket number'),
          ),
        );
        return;
      }

      // Disable the "Confirm TN" button after initializing values
      setState(() {
        isButtonEnabled = false;
      });

      // Check if all required fields are initialized
      bool isDataInitialized = fnameController.text.isNotEmpty &&
          lnameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          amountController.text.isNotEmpty;

      // Enable the "Continue to Payment" button if data is initialized
      setState(() {
        isPaymentButtonEnabled = isDataInitialized;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
