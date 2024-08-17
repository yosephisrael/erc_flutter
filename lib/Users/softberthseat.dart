import 'package:erbs/Users/passengerDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SoftBerthSeat {
  final String seatNumber;
  final int compartmentIndex; // Add compartmentIndex field
  bool isBooked;
  bool isReserved;

  SoftBerthSeat(
      this.seatNumber, this.compartmentIndex, this.isBooked, this.isReserved);
}

class SoftBerthSeatMapScreen extends StatefulWidget {
  final String startpoint;
  final String destinationpoint;
  final String starttime;
  final String finishtime;
  final String pricing;
  final String selectedclass;
  final String selectedate;
  final String sbfrom;
  final String sbto;

  SoftBerthSeatMapScreen({
    required this.startpoint,
    required this.destinationpoint,
    required this.starttime,
    required this.finishtime,
    required this.pricing,
    required this.selectedclass,
    required this.selectedate,
    required this.sbfrom,
    required this.sbto,
  });
  @override
  _SoftBerthSeatMapScreenState createState() => _SoftBerthSeatMapScreenState();
}

class _SoftBerthSeatMapScreenState extends State<SoftBerthSeatMapScreen> {
  late List<List<List<List<SoftBerthSeat>>>> compartments;
  SoftBerthSeat? selectedSeat; // Store the selected seat

  @override
  initState() {
    super.initState();
    _initializeCompartments();
  }

  Future<void> _initializeCompartments() async {
    // Initialize compartments with seats
    compartments = List.generate(
      1, // Only one compartment
      (compartmentIndex) => List.generate(
        20, // 20 rows
        (rowIndex) => List.generate(
          2,
          (columnIndex) {
            final String rowLabel = (rowIndex * 1 + 1).toString();
            final String upperLabel =
                '$rowLabel${columnIndex == 0 ? 'U' : 'L'}';
            final String lowerLabel =
                '${int.parse(rowLabel) + 1}${columnIndex == 0 ? 'U' : 'L'}';
            final List<SoftBerthSeat> seats = [
              SoftBerthSeat(upperLabel, compartmentIndex, false, false),
              SoftBerthSeat(lowerLabel, compartmentIndex, false, false),
            ];
            return seats;
          },
        ),
      ),
    );
    // Fetch Firestore data and update seats
    await fetchDataAndUpdateSeats();
    setState(() {});
  }

  // Method to fetch Firestore data and update seats
  Future<void> fetchDataAndUpdateSeats() async {
    // Replace 'selecteddate' with the actual date you're fetching data for
    final date = widget.selectedate;
    final compartmentsCollection = FirebaseFirestore.instance
        .collection('Soft Berth Selection')
        .doc(date)
        .collection('compartments');

    final compartmentDoc = await compartmentsCollection.doc('1').get();

    if (compartmentDoc.exists) {
      final seatsCollection = compartmentDoc.reference.collection('seats');
      final seatsDocs = await seatsCollection.get();

      // Update seats based on Firestore data
      seatsDocs.docs.forEach((doc) {
        final seatNumber = doc.id;
        final isBooked = doc['isBooked'] ?? false;
        final isReserved = doc['isReserved'] ?? false;

        // Find and update the corresponding seat in the compartments list
        for (int i = 0; i < compartments[0].length; i++) {
          for (int j = 0; j < compartments[0][i].length; j++) {
            SoftBerthSeat seat = compartments[0][i][j][0];
            if (seat.seatNumber == seatNumber) {
              setState(() {
                seat.isBooked = isBooked;
                seat.isReserved = isReserved;
              });
            }
          }
        }
      });
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
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 25),
                const Text(
                  'Soft Berth Seat Selection',
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
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
                top: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade800,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Taken Seat',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3F7347),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Free Seat',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.red.shade800,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Reserved Seat',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  compartments.length,
                  (compartmentIndex) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Compartment ${compartmentIndex + 1}',
                            style: const TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Left Inner Container
                              Container(
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
                                  children: List.generate(
                                    5, // 5 inner containers
                                    (innerContainerIndex) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Upper row
                                            Column(
                                              children: List.generate(
                                                2, // 2 consecutive rows
                                                (rowIndex) {
                                                  final seats = compartments[
                                                          compartmentIndex][
                                                      (innerContainerIndex *
                                                              2) +
                                                          rowIndex][0];
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: List.generate(
                                                      1, // 1 seat in each row
                                                      (seatIndex) => SeatWidget(
                                                        seats[seatIndex],
                                                        widget.selectedate,
                                                        selectedSeat, // Pass selected seat
                                                        onSeatSelected:
                                                            (selectedSeat) {
                                                          setState(() {
                                                            this.selectedSeat =
                                                                selectedSeat;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            // Lower row
                                            Column(
                                              children: List.generate(
                                                2, // 2 consecutive rows
                                                (rowIndex) {
                                                  final seats = compartments[
                                                          compartmentIndex][
                                                      (innerContainerIndex *
                                                              2) +
                                                          rowIndex][1];
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: List.generate(
                                                      1, // 1 seat in each row
                                                      (seatIndex) => SeatWidget(
                                                        seats[seatIndex],
                                                        widget.selectedate,
                                                        selectedSeat, // Pass selected seat
                                                        onSeatSelected:
                                                            (selectedSeat) {
                                                          setState(() {
                                                            this.selectedSeat =
                                                                selectedSeat;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: selectedSeat != null
                  ? () {
                      // Extract selected seat in the specified format
                      String selectedSeatInfo =
                          '${selectedSeat!.seatNumber} in Compartment ${selectedSeat!.compartmentIndex + 1}';
                      // Show dialog with selected seat information
                      // Navigate to passengerDetailScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PassengerDetail(
                            startPoint: widget.startpoint,
                            destinationPoint: widget.destinationpoint,
                            startingtime: widget.starttime,
                            finishingtime: widget.finishtime,
                            pricingDetail: widget.pricing,
                            selectedclasstype: widget.selectedclass,
                            selectejourneydate: widget.selectedate,
                            selectedSeatLabel: selectedSeatInfo,
                            Pdfrom: widget.sbfrom,
                            Pdto: widget.sbto,
                          ),
                        ),
                      );
                    }
                  : null, // Disable the button if no seat is selected
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSeat != null
                    ? Colors.yellow.shade700
                    : Colors
                        .grey.shade400, // Change color based on seat selection
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                elevation: 5,
                minimumSize: const Size(200, 40),
              ),
              child: const Text(
                'Confirm Seat',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SeatWidget extends StatefulWidget {
  final SoftBerthSeat seat;
  final String selectedate;
  final SoftBerthSeat? selectedSeat; // Store the selected seat
  final Function(SoftBerthSeat?) onSeatSelected; // Modify this line

  SeatWidget(this.seat, this.selectedate, this.selectedSeat,
      {required this.onSeatSelected}); // Update this line

  @override
  State<SeatWidget> createState() => _SeatWidgetState();
}

class _SeatWidgetState extends State<SeatWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Soft Berth Selection')
          .doc(widget.selectedate) // Use widget.selectedate
          .collection('compartments')
          .doc((widget.seat.compartmentIndex + 1).toString())
          .collection('seats')
          .doc(widget.seat.seatNumber.toString())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSeat(widget.seat.isBooked,
              widget.seat.isReserved); // Return a placeholder
        } else {
          final isBooked = snapshot.data?['isBooked'] ?? false;
          final isReserved = snapshot.data?['isReserved'] ?? false;
          return _buildSeat(isBooked, isReserved);
        }
      },
    );
  }

  Widget _buildSeat(bool isBooked, bool isReserved) {
    final isSelected = widget.selectedSeat == widget.seat;

    return GestureDetector(
      onTap: () {
        if (isBooked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Sorry, this seat is already purchased. Please select another one.'),
            ),
          );
        } else if (isReserved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Sorry, this seat is reserved. Please select another one.'),
            ),
          );
        } else {
          setState(() {
            if (isSelected) {
              widget.onSeatSelected(null);
            } else {
              widget.onSeatSelected(widget.seat);
            }
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 40,
          height: 30,
          decoration: BoxDecoration(
            color: isBooked
                ? Colors.yellow.shade800
                : isReserved
                    ? Colors.red // Set color to red for reserved seats
                    : isSelected
                        ? Colors.yellow.shade800
                        : const Color(0xFF3F7347),
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              widget.seat.seatNumber,
              style: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
