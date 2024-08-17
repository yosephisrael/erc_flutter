import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/book.dart';
import 'package:erbs/Users/bookRound.dart';
import 'package:erbs/Users/confirmBook.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:erbs/Users/roundConfirmBook.dart';
import 'package:flutter/material.dart';

class RoundJourneyScreen extends StatelessWidget {
  final String start;
  final String destination;
  final String startTime;
  final String finishTime;
  final String price;
  final String selectedClass;
  final String selectedDate;
  final String selectedReturnDate;
  final String returnstartPoint;
  final String returndestinationPoint;
  final String returnStarttime;
  final String returnFinishtime;
  final String rafrom;
  final String rato;

  const RoundJourneyScreen({
    Key? key,
    required this.start,
    required this.destination,
    required this.startTime,
    required this.finishTime,
    required this.price,
    required this.selectedClass,
    required this.selectedDate,
    required this.selectedReturnDate,
    required this.returnstartPoint,
    required this.returndestinationPoint,
    required this.returnStarttime,
    required this.returnFinishtime,
    required this.rafrom,
    required this.rato,
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => BookRoundPage(
                            from: start,
                            to: destination,
                          )),
                );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 5.0), // Adjusted padding
                  child: Text(
                    start.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 15,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.train,
                    color: Color(0xFF3F7347),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0), // Adjusted padding
                  child: Text(
                    destination.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                color: Colors.black,
                onPressed: () {
                  // Navigate to home screen or perform any action
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()),
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
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Journey Date',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedDate,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Return Date',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedReturnDate,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
            ),
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Fares')
                  .where('start', isEqualTo: start)
                  .where('destination', isEqualTo: destination)
                  .where('price', isEqualTo: price)
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors
                          .green), // Change the color of the progress indicator
                      strokeWidth:
                          3, // Adjust the stroke width of the progress indicator
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Display error message if an error occurs
                } else {
                  final numberOfJourneys = snapshot.data!.docs.length;
                  final availableJourneysText = numberOfJourneys == 1
                      ? '1 available Journey'
                      : '$numberOfJourneys available Journeys';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Available Journeys',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        availableJourneysText,
                        style: const TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 15,
                        ),
                      ), // Display the number of available journeys
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10), // Outer padding
            child: Container(
              constraints: const BoxConstraints(maxHeight: 390),
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
                    padding: const EdgeInsets.all(20), // Inner padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedDate,
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.w100,
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10), // Increased height
                        Row(
                          children: [
                            Text(
                              start,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 1, // Height of the divider line
                              width: MediaQuery.of(context).size.width /
                                  10, // Width of the line
                              color: Colors.grey, // Color of the line
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.train,
                              color:
                                  Color(0xFF3F7347), // Color of the train icon
                            ),
                            const Spacer(),
                            Container(
                              height: 1, // Height of the divider line
                              width: MediaQuery.of(context).size.width /
                                  10, // Width of the line
                              color: Colors.grey, // Color of the line
                            ),
                            const Spacer(),
                            Text(
                              destination,
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
                          children: [
                            Text(
                              startTime,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              finishTime,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Material(
                          elevation: 2, // Adjust the elevation value as needed
                          shadowColor:
                              Colors.grey.withOpacity(0.5), // Shadow color
                          child: Container(
                            height: 1, // Height of the divider line
                            width: MediaQuery.of(context)
                                .size
                                .width, // Width of the line
                            color: Colors.grey, // Color of the line
                          ),
                        ),
                        const SizedBox(height: 10), // Increased height
                        Text(
                          selectedReturnDate,
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.w100,
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10), // Increased height
                        Row(
                          children: [
                            Text(
                              destination,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 1, // Height of the divider line
                              width: MediaQuery.of(context).size.width /
                                  10, // Width of the line
                              color: Colors.grey, // Color of the line
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.train,
                              color:
                                  Color(0xFF3F7347), // Color of the train icon
                            ),
                            const Spacer(),
                            Container(
                              height: 1, // Height of the divider line
                              width: MediaQuery.of(context).size.width /
                                  10, // Width of the line
                              color: Colors.grey, // Color of the line
                            ),
                            const Spacer(),
                            Text(
                              start,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        // Increased height
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              returnFinishtime,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              returnStarttime,
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // Increased height
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${(2 * int.parse(price)).toString()} ETB', // Double the price
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
                  Center(
                    // Move Center widget here
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RoundConfirmBook(
                                startpoint: start,
                                destinationpoint: destination,
                                starttime: startTime,
                                finishtime: finishTime,
                                pricing: price,
                                selectedclass: selectedClass,
                                selectedate: selectedDate,
                                selectedReturndate: selectedReturnDate,
                                returnstartpoint: returnstartPoint,
                                returndestinationpoint: returndestinationPoint,
                                returnStartTime: returnStarttime,
                                returnFinishTime: returnFinishtime,
                                rcfrom: rafrom,
                                rcto: rato,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F7347),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 5), // Decreased vertical padding
                          elevation: 10,
                          minimumSize:
                              const Size(150, 30), // Decreased button size
                        ),
                        child: const Text('Select',
                            style:
                                TextStyle(fontFamily: 'DMSans', fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
