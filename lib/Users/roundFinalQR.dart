import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RoundfinalQR extends StatefulWidget {
  final String fname;
  final String lname;
  final String email;
  final String phone;
  final String stPoint;
  final String destPoint;
  final String sttime;
  final String fintime;
  final String priDetai;
  final String uniqueTicket;
  final String selclass;
  final String seldate;
  final String selseat;
  final String txRef;
  final String selectedReturningDate;
  final String returnstartingPoint;
  final String returndestinationingPoint;
  final String returnStartingtime;
  final String returnFinishingtime;

  const RoundfinalQR({
    Key? key,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.stPoint,
    required this.destPoint,
    required this.sttime,
    required this.fintime,
    required this.priDetai,
    required this.uniqueTicket,
    required this.selclass,
    required this.seldate,
    required this.selseat,
    required this.txRef,
    required this.selectedReturningDate,
    required this.returnstartingPoint,
    required this.returndestinationingPoint,
    required this.returnStartingtime,
    required this.returnFinishingtime,
  }) : super(key: key);

  @override
  State<RoundfinalQR> createState() => _RoundfinalQRState();
}

class _RoundfinalQRState extends State<RoundfinalQR> {
  @override
  void initState() {
    super.initState();
    // Call the methods here when the page starts
    addPassengersPaid(widget.txRef);
    updateFirestoreAfterPayment();
  }

  @override
  Widget build(BuildContext context) {
    String newPricing = (int.parse(widget.priDetai) * 2).toString();
    // Combine the information into a single string
    DateTime currentDate = DateTime.now();

// Format currentDate to match the format used in widget.seldate and widget.selectedReturningDate
    String formattedCurrentDate = DateFormat('E, MMM d').format(currentDate);

// Compare seldate with the current date
    bool isSeldateToday = widget.seldate == formattedCurrentDate;

// Compare selectedReturningDate with the current date
    bool isSelectedReturningDateToday =
        widget.selectedReturningDate == formattedCurrentDate;

// Create a string value based on the comparison results
    String dateValidity =
        (isSeldateToday && isSelectedReturningDateToday) ? 'Invalid' : 'Valid';
    String combinedInfo =
        '$dateValidity\n Round Journey \n First Name: ${widget.fname}\n Last Name: ${widget.lname}\n Email: ${widget.email}\n Phone: ${widget.phone}\n Start: ${widget.stPoint}\n Arrival: ${widget.destPoint}\n Start Time: ${widget.sttime}\n Arrival Time: ${widget.fintime}\n Amount Paid: $newPricing\n Ticket Number: ${widget.uniqueTicket}\n Transaction Ref: ${widget.txRef}';
    String qrCodeData = combinedInfo;
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
            automaticallyImplyLeading: false, // Remove default back arrow
            title: const Center(
              child: Text(
                'QR Result',
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
      body: Column(
        children: [
          Container(
            height: 1, // Horizontal line height
            color: Colors.grey, // Line color
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range_outlined,
                      color: Color(0xFF3F7347),
                    ),
                    Text(
                      ': ${widget.seldate}',
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      widget.stPoint,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.train,
                      color: Color(0xFF3F7347),
                    ),
                    const Spacer(),
                    Text(
                      widget.destPoint,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.sttime,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.fintime,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Material(
                  elevation: 2, // Adjust the elevation value as needed
                  shadowColor: Colors.grey.withOpacity(0.5), // Shadow color
                  child: Container(
                    height: 1, // Height of the divider line
                    width:
                        MediaQuery.of(context).size.width, // Width of the line
                    color: Colors.grey, // Color of the line
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range_outlined,
                      color: Color(0xFF3F7347),
                    ),
                    Text(
                      ': ${widget.selectedReturningDate}',
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      widget.returndestinationingPoint,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.train,
                      color: Color(0xFF3F7347),
                    ),
                    const Spacer(),
                    Text(
                      widget.returnstartingPoint,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.returnFinishingtime,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.returnStartingtime,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Class: ${widget.selclass}',
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.chair,
                          color: Color(0xFF3F7347),
                        ),
                        Text(
                          ': ${widget.selseat}',
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.money,
                          color: Color(0xFF3F7347),
                        ),
                        Text(
                          ': ${(2 * int.parse(widget.priDetai)).toString()} ETB',
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF3F7347),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Tx Reference: ${widget.txRef}',
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            height: 1, // Horizontal line height
            color: Colors.grey, // Line color
          ),
          const SizedBox(height: 30),
          Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF3F7347),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Please Make Sure to Screen Capture your Generated QR for later use!',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _saveQRToGallery(context, qrCodeData);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'QR Ticket',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF3F7347),
                        ),
                      ),
                      const SizedBox(height: 10),
                      QrImageView(
                        data: combinedInfo,
                        version: QrVersions.auto,
                        size: 140.0,
                        foregroundColor:
                            Colors.black, // Set the foreground color to black
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Scan to Validate',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 16,
                          color: Colors.black54,
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
    );
  }

  Future<void> _saveQRToGallery(BuildContext context, String qrCodeData) async {
    // Show an alert dialog to confirm saving the QR code to the gallery
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.download,
                color: Colors.white, // Change error icon color
              ),
              SizedBox(width: 10),
              Text(
                'Save QR Code to Gallery?',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: Colors.white, // Change title text color
                  fontSize: 18, // Adjust title font size
                ),
              ),
            ],
          ),
          content: const Text(
            'Do you want to save the QR code to your gallery?',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: Colors.white, // Change title text color
              fontSize: 15, // Adjust title font size
            ),
          ),
          backgroundColor: const Color(0xFF3F7347),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 10), // Change background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Add rounded corners
            side: const BorderSide(color: Color(0xFF3F7347)), // Add border
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'No',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: Colors.white, // Change title text color
                  fontSize: 15, // Adjust title font size
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Save the QR code to the gallery
                try {
                  final painter = QrPainter(
                    data: qrCodeData,
                    version: QrVersions.auto,
                    errorCorrectionLevel: QrErrorCorrectLevel.L,
                  );

                  const imageSize = 300.0;
                  final image = await painter.toImage(imageSize);
                  final byteData =
                      await image.toByteData(format: ui.ImageByteFormat.png);
                  final bytes = byteData!.buffer.asUint8List();

                  // Save the QR code image to gallery
                  final result = await ImageGallerySaver.saveImage(bytes);
                  if (result != null && result.isNotEmpty) {
                    print('QR code saved to gallery');

                    // // Save the QR code to Firestore
                    // await FirebaseFirestore.instance
                    //     .collection('Purchased Tickets')
                    //     .doc(widget.uniqueTicket)
                    //     .set({
                    //   'QRCode': bytes,
                    //   // Add other fields as needed
                    // });
                  } else {
                    print('Failed to save QR code to gallery');
                  }
                } catch (e) {
                  print('Error saving QR code: $e');
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: Colors.white, // Change title text color
                  fontSize: 15, // Adjust title font size
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> addPassengersPaid(String TxRef) async {
    try {
      String selectedCollection;
      String ticket = widget.uniqueTicket;

      // Determine the Firestore collection based on selected class type
      if (widget.selclass == 'Hard Seat') {
        selectedCollection = 'Round Hard Seat Passenger';
      } else if (widget.selclass == 'Hard Berth') {
        selectedCollection = 'Round Hard Berth Passenger';
      } else if (widget.selclass == 'Soft Berth') {
        selectedCollection = 'Round Soft Berth Passenger';
      } else {
        // Handle other cases or set a default collection
        selectedCollection =
            'Other Passenger'; // You can customize this as needed
      }

      // Construct the path to the Firestore document
      String documentPath = '$selectedCollection/$ticket';
      String newPrice = (int.parse(widget.priDetai) * 2).toString();

      // Update Firestore with payment details
      await FirebaseFirestore.instance.doc(documentPath).set({
        'First Name': widget.fname,
        'Last Name': widget.lname,
        'Email': widget.email,
        'Phone': widget.phone,
        'Starting Point': widget.stPoint,
        'Destination Point': widget.destPoint,
        'Starting Timing': widget.sttime,
        'Finishing Timing': widget.fintime,
        'Selected Class Type': widget.selclass,
        'Selected Journey Date': widget.seldate,
        'Selected Seat': widget.selseat,
        'Amount Paid': newPrice,
        'Transaction Reference': TxRef,
        'Return Date': widget.selectedReturningDate,
        'Return Start Point': widget.returndestinationingPoint,
        'Return Destination Point': widget.returnstartingPoint,
        'Return Start Time': widget.returnFinishingtime,
        'Return Finish Time': widget.returnStartingtime,
      });

      print('Payment details added to Firestore.');
    } catch (e) {
      print('Error updating Firestore: $e');
    }
  }

  Future<void> updateFirestoreAfterPayment() async {
    try {
      // Split the selected seat information
      List<String> selectedSeatInfo = widget.selseat.split(', ');

      // Iterate over each selected seat
      for (String seatInfo in selectedSeatInfo) {
        // Extract seat number and compartment index from seat information
        List<String> parts = seatInfo.split(' in Compartment ');
        String seatNumber = parts[0];
        int compartmentIndex = int.parse(parts[1]);

        String selectedDateYYYYMMDD = widget.seldate;
        String seatDocumentPath;

        // Determine the seatDocumentPath based on selected seat type
        if (widget.selclass == 'Hard Seat') {
          seatDocumentPath =
              'Hard Seat Selection/$selectedDateYYYYMMDD/compartments/$compartmentIndex/seats/$seatNumber';
        } else if (widget.selclass == 'Hard Berth') {
          seatDocumentPath =
              'Hard Berth Selection/$selectedDateYYYYMMDD/compartments/$compartmentIndex/seats/$seatNumber';
        } else if (widget.selclass == 'Soft Berth') {
          seatDocumentPath =
              'Soft Berth Selection/$selectedDateYYYYMMDD/compartments/$compartmentIndex/seats/$seatNumber';
        } else {
          // Handle any other type of seat here
          // For example, throw an error or provide a default path
          // You can customize this based on your application logic
          throw Exception('Invalid seat type');
        }

        // Update the Firestore document
        await FirebaseFirestore.instance.doc(seatDocumentPath).update({
          'isBooked': true,
        });

        print('Seat $seatNumber updated in Firestore.');
      }
    } catch (e) {
      print('Error updating Firestore: $e');
    }
  }
}
