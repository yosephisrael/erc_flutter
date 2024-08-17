import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/finalQR.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:erbs/Users/passengerDetails.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';

class Payment extends StatefulWidget {
  final String startingPoint;
  final String destinationingPoint;
  final String startingtiming;
  final String finishingtiming;
  final String pricingDetailing;
  final String selectedclasstyping;
  final String selectejourneydating;
  final String uniqueticket;
  final String selectedseat;

  const Payment({
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
  }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false; // Track button enabled state
  TextEditingController ticketNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    initializeFields();
    amountController.text = widget.pricingDetailing;
    currencyController.text = 'ETB';
  }

  Future<void> initializeFields() async {
    try {
      var passengerSnapshot = await FirebaseFirestore.instance
          .collection('Passengers')
          .where('ticketnumber', isEqualTo: widget.uniqueticket)
          .limit(1)
          .get();

      if (passengerSnapshot.docs.isNotEmpty) {
        var passengerData = passengerSnapshot.docs.first.data();
        setState(() {
          fnameController.text = passengerData['firstname'];
          lnameController.text = passengerData['lastname'];
          emailController.text = passengerData['email'];
          phoneController.text = passengerData['phone'];
        });
      } else {
        print(
            'No passenger data found for ticket number: ${widget.uniqueticket}');
      }
    } catch (e) {
      print('Error fetching passenger information: $e');
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const HomePage(),
                  ),
                );
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage(),
                    ),
                  );
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
                          widget.startingPoint!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Icon(Icons.arrow_right_alt_rounded,
                            color: Color(0xFF3F7347)),
                        Text(
                          widget.destinationingPoint!,
                          style: const TextStyle(
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
                          widget.selectejourneydating!,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const Spacer(),
                        Text(
                          'ETB ${widget.pricingDetailing}',
                          style: const TextStyle(
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
                              ),
                              onChanged: (value) {
                                setState(() {
                                  isButtonEnabled = value
                                      .isNotEmpty; // Enable button if value is not empty
                                });
                              },
                              validator: _validateTicketNumber,
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: isButtonEnabled
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
                          horizontal: 70, vertical: 10),
                      elevation: 10,
                      minimumSize: const Size(250, 40),
                    ),
                    child: const Text('Continue to Payment',
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

  Future<void> _pay(BuildContext context, String TxRef) async {
    // Check if the ticket number matches the user's data
    bool isTicketValid = await _validateTicket();

    if (!isTicketValid) {
      // Show an AlertDialog with the appropriate error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text('Error',
                    style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 18,
                        color: Colors.white)),
              ],
            ),
            content: const Text(
                'Ticket number expired or incorrect. Please enter a valid ticket number.',
                style: TextStyle(
                    fontFamily: 'DMSans', fontSize: 15, color: Colors.white)),
            backgroundColor: const Color(0xFF3F7347),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Color(0xFF3F7347)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
      return;
    }

    try {
      // Proceed with payment
      await Chapa.getInstance.startPayment(
        context: context,
        onInAppPaymentSuccess: (successMsg) {
          setState(() {
            isloading = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => finalQR(
                fname: fnameController.text,
                lname: lnameController.text,
                email: emailController.text,
                phone: phoneController.text,
                stPoint: widget.startingPoint,
                destPoint: widget.destinationingPoint,
                sttime: widget.startingtiming,
                fintime: widget.finishingtiming,
                priDetai: widget.pricingDetailing,
                uniqueTicket: widget.uniqueticket,
                selclass: widget.selectedclasstyping,
                seldate: widget.selectejourneydating,
                selseat: widget.selectedseat,
                txRef: TxRef,
              ),
            ),
          );
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

  Future<bool> _validateTicket() async {
    try {
      var passengerSnapshot = await FirebaseFirestore.instance
          .collection('Passengers')
          .where('ticketnumber', isEqualTo: ticketNumberController.text)
          .limit(1)
          .get();

      if (passengerSnapshot.docs.isNotEmpty) {
        var passengerData = passengerSnapshot.docs.first.data();
        return fnameController.text == passengerData['firstname'] &&
            lnameController.text == passengerData['lastname'] &&
            emailController.text == passengerData['email'] &&
            phoneController.text == passengerData['phone'];
      } else {
        // Ticket number not found in database
        return false;
      }
    } catch (e) {
      print('Error validating ticket: $e');
      return false;
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
}
