import 'package:erbs/Users/passengerDetails.dart';
import 'package:erbs/Users/roundPassengerDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Seat {
  final String seatNumber;
  final int compartmentIndex; // Add compartmentIndex field
  bool isBooked;
  bool isReserved;

  Seat(this.seatNumber, this.compartmentIndex, this.isBooked, this.isReserved);
}

class RoundHardSeatMapScreen extends StatefulWidget {
  final String startpoint;
  final String destinationpoint;
  final String starttime;
  final String finishtime;
  final String pricing;
  final String selectedclass;
  final String selectedate;
  final String selectedReturningdate;
  final String returnstartingpoint;
  final String returndestinationingpoint;
  final String returnStartingTime;
  final String returnFinishingTime;
  final String rhsfrom;
  final String rhsto;

  RoundHardSeatMapScreen({
    required this.startpoint,
    required this.destinationpoint,
    required this.starttime,
    required this.finishtime,
    required this.pricing,
    required this.selectedclass,
    required this.selectedate,
    required this.selectedReturningdate,
    required this.returnstartingpoint,
    required this.returndestinationingpoint,
    required this.returnStartingTime,
    required this.returnFinishingTime,
    required this.rhsfrom,
    required this.rhsto,
  });

  @override
  _RoundHardSeatMapScreenState createState() => _RoundHardSeatMapScreenState();
}

class _RoundHardSeatMapScreenState extends State<RoundHardSeatMapScreen> {
  late List<List<List<Seat>>> compartments;
  Seat? selectedSeats;

  @override
  void initState() {
    super.initState();
    _initializeCompartments();
  }

  Future<void> _initializeCompartments() async {
    compartments = List.generate(
      6,
      (compartmentIndex) => List.generate(
        10,
        (rowIndex) {
          final int seatNumber = (rowIndex * 5) + 1;
          final String seatLabel = '${rowIndex + 1}';
          return List.generate(
            5,
            (columnIndex) => Seat(
                '${seatLabel}${String.fromCharCode(65 + columnIndex)}',
                compartmentIndex,
                false,
                false),
          );
        },
      ),
    );

    await _loadSeatStatus();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadSeatStatus() async {
    for (var compartmentIndex = 1;
        compartmentIndex <= compartments.length;
        compartmentIndex++) {
      for (var rowIndex = 0; rowIndex < compartments[0].length; rowIndex++) {
        for (var columnIndex = 0;
            columnIndex < compartments[0][0].length;
            columnIndex++) {
          final seatNumber = (rowIndex * 5) + 1;
          final seatDoc = await FirebaseFirestore.instance
              .collection('Hard Seat Selection')
              .doc(widget.selectedate)
              .collection('compartments')
              .doc(compartmentIndex.toString())
              .collection('seats')
              .doc(seatNumber.toString())
              .get();

          final isBooked = seatDoc.exists ? seatDoc['isBooked'] : false;
          final isReserved = seatDoc.exists ? seatDoc['isReserved'] : false;
          compartments[compartmentIndex - 1][rowIndex][columnIndex].isBooked =
              isBooked;
          compartments[compartmentIndex - 1][rowIndex][columnIndex].isReserved =
              isReserved;
        }
      }
    }
  }

  void _toggleSeatSelection(Seat seat) {
    if (seat.isBooked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Sorry, this seat is already Purchased. Please select another seat.'),
        ),
      );
      return;
    }
    if (seat.isReserved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Sorry, this seat is already reserved. Please select another seat.'),
        ),
      );
      return;
    }
    setState(() {
      if (selectedSeats != null && selectedSeats == seat) {
        selectedSeats = null;
      } else {
        selectedSeats = seat;
      }
    });
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
                  'Hard Seat Selection',
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
                      padding: const EdgeInsets.all(10), // Add padding
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
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: List.generate(
                                10,
                                (rowIndex) {
                                  final seats =
                                      compartments[compartmentIndex][rowIndex];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(
                                      seats.length,
                                      (seatIndex) => GestureDetector(
                                        onTap: () {
                                          _toggleSeatSelection(
                                              seats[seatIndex]);
                                        },
                                        child: SeatWidget(
                                          seats[seatIndex],
                                          widget.selectedate,
                                          selectedSeats,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
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
              onPressed: selectedSeats != null
                  ? () {
                      final selectedSeatLabel =
                          '${selectedSeats!.seatNumber} in Compartment ${selectedSeats!.compartmentIndex + 1}';
                      // Navigate to passengerDetailScreen with selected seats
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoundPassengerDetail(
                            startPoint: widget.startpoint,
                            destinationPoint: widget.destinationpoint,
                            startingtime: widget.starttime,
                            finishingtime: widget.finishtime,
                            pricingDetail: widget.pricing,
                            selectedclasstype: widget.selectedclass,
                            selectejourneydate: widget.selectedate,
                            selectedSeatLabel: selectedSeatLabel,
                            returnstartingPoint: widget.returnstartingpoint,
                            returndestinationingPoint:
                                widget.returndestinationingpoint,
                            returnStartingtime: widget.returnStartingTime,
                            returnFinishingtime: widget.returnFinishingTime,
                            selectedReturningDate: widget.selectedReturningdate,
                            rpdfrom: widget.rhsfrom,
                            rpdto: widget.rhsto,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                elevation: 5,
                minimumSize: const Size(200, 40),
              ),
              child: const Text('Confirm Seat',
                  style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final String selectedate;
  final Seat? selectedSeat;

  SeatWidget(this.seat, this.selectedate, this.selectedSeat);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Hard Seat Selection')
          .doc(selectedate)
          .collection('compartments')
          .doc((seat.compartmentIndex + 1).toString())
          .collection('seats')
          .doc(seat.seatNumber)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSeat(seat.isBooked, seat.isReserved);
        } else {
          final data = snapshot.data?.data() as Map<String, dynamic>?;

          final isBooked = data?['isBooked'] ?? false;
          final isReserved = data?['isReserved'] ?? false;

          return _buildSeat(isBooked, isReserved);
        }
      },
    );
  }

  Widget _buildSeat(bool isBooked, bool isReserved) {
    final isSelected = selectedSeat == seat;
    Color seatColor;
    if (isBooked) {
      seatColor = Colors.yellow.shade800;
    } else if (isReserved) {
      seatColor = Colors.red.shade800;
    } else if (isSelected) {
      seatColor = Colors.yellow.shade800;
    } else {
      seatColor = const Color(0xFF3F7347);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 30,
        decoration: BoxDecoration(
          color: seatColor,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            seat.seatNumber,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
