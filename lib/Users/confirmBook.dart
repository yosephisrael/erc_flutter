import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hardberthseat.dart';
import 'hardseat.dart';
import 'softberthseat.dart';
import 'homePage.dart';

class ConfirmBook extends StatelessWidget {
  final String startpoint;
  final String destinationpoint;
  final String starttime;
  final String finishtime;
  final String pricing;
  final String selectedclass;
  final String selectedate;
  final String cfrom;
  final String cto;

  const ConfirmBook({
    Key? key,
    required this.startpoint,
    required this.destinationpoint,
    required this.starttime,
    required this.finishtime,
    required this.pricing,
    required this.selectedclass,
    required this.selectedate,
    required this.cfrom,
    required this.cto,
  }) : super(key: key);

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
                Navigator.of(context).pop();
              },
            ),
            title: const Center(
              child: Text(
                'Trip Summary',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Class',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  selectedclass,
                  style: const TextStyle(
                    fontFamily: 'DMSans',
                    color: Color(0xFF3F7347),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 280),
              margin: const EdgeInsets.all(20),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              starttime,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              finishtime,
                              style: const TextStyle(
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
                              selectedate,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w100,
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              selectedate,
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
                              startpoint,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width / 10,
                              color: Colors.grey,
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.train,
                              color: Color(0xFF3F7347),
                            ),
                            const Spacer(),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width / 10,
                              color: Colors.grey,
                            ),
                            const Spacer(),
                            Text(
                              destinationpoint,
                              style: const TextStyle(
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
                              '$pricing ETB',
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFF3F7347),
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
          Container(
            padding: const EdgeInsets.all(10),
            height: 150,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1.0),
                bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seat Selection',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Available after payment',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Change Fee',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Refund Fee',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '150 ETB',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '19.84 % of Total Payment',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  _navigateToSeatSelection(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F7347),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 5,
                  ),
                  elevation: 10,
                  minimumSize: const Size(250, 40),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void SeatSelectionScreen(BuildContext context) {
    if (selectedclass == 'Hard Seat') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HardSeatMapScreen(
          startpoint: startpoint,
          destinationpoint: destinationpoint,
          starttime: starttime,
          finishtime: finishtime,
          pricing: pricing,
          selectedclass: selectedclass,
          selectedate: selectedate,
          hsfrom: cfrom,
          hsto: cto,
        ),
      ));
    } else if (selectedclass == 'Hard Berth') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HardBerthSeatMapScreen(
          startpoint: startpoint,
          destinationpoint: destinationpoint,
          starttime: starttime,
          finishtime: finishtime,
          pricing: pricing,
          selectedclass: selectedclass,
          selectedate: selectedate,
          hbfrom: cfrom,
          hbto: cto,
        ),
      ));
    } else if (selectedclass == 'Soft Berth') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => SoftBerthSeatMapScreen(
          startpoint: startpoint,
          destinationpoint: destinationpoint,
          starttime: starttime,
          finishtime: finishtime,
          pricing: pricing,
          selectedclass: selectedclass,
          selectedate: selectedate,
          sbfrom: cfrom,
          sbto: cto,
        ),
      ));
    }
  }

  void _navigateToSeatSelection(BuildContext context) {
    // Check for Hard Seat passengers
    FirebaseFirestore.instance
        .collection('Hard Seat Passenger')
        .get()
        .then((querySnapshot) {
      int numberOfHardSeatPassengers = querySnapshot.size;
      FirebaseFirestore.instance
          .collection('Maximum Collection')
          .doc(selectedate)
          .collection('$startpoint' + '_' + '$destinationpoint')
          .doc('data')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic>? data = documentSnapshot.data();
        int maxHardSeatPassengers = data?['Hard Seat'] ?? 0;
        if (numberOfHardSeatPassengers >= maxHardSeatPassengers) {
          _showJourneyFullDialog(context, 'Hard Seat');
        } else {
          // Check for Hard Berth passengers
          FirebaseFirestore.instance
              .collection('Hard Berth Passenger')
              .get()
              .then((querySnapshot) {
            int numberOfHardBerthPassengers = querySnapshot.size;
            int maxHardBerthPassengers = data?['Hard Berth'] ?? 0;
            if (numberOfHardBerthPassengers >= maxHardBerthPassengers) {
              _showJourneyFullDialog(context, 'Hard Berth');
            } else {
              // Check for Soft Berth passengers
              FirebaseFirestore.instance
                  .collection('Soft Berth Passenger')
                  .get()
                  .then((querySnapshot) {
                int numberOfSoftBerthPassengers = querySnapshot.size;
                int maxSoftBerthPassengers = data?['Soft Berth'] ?? 0;
                if (numberOfSoftBerthPassengers >= maxSoftBerthPassengers) {
                  _showJourneyFullDialog(context, 'Soft Berth');
                } else {
                  // Navigate to seat selection
                  SeatSelectionScreen(context);
                }
              });
            }
          });
        }
      });
    });
  }

  void _showJourneyFullDialog(BuildContext context, String passengerType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.train,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'Journey Full',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'The selected journey is full for $passengerType passengers for the date: $selectedate',
            style: const TextStyle(
              fontFamily: 'DMSans',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xFF3F7347),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Color(0xFF3F7347)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
