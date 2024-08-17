import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/book.dart';
import 'package:erbs/Users/confirmBook.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:flutter/material.dart';

class JourneyScreen extends StatelessWidget {
  final String start;
  final String destination;
  final String startTime;
  final String finishTime;
  final String price;
  final String selectedClass;
  final String selectedDate;
  final String afrom;
  final String ato;

  const JourneyScreen({
    Key? key,
    required this.start,
    required this.destination,
    required this.startTime,
    required this.finishTime,
    required this.price,
    required this.selectedClass,
    required this.selectedDate,
    required this.afrom,
    required this.ato,
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
                      builder: (BuildContext context) => BookPage(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date',
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
                        const SizedBox(height: 15), // Increased height
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
                        const SizedBox(height: 15), // Increased height
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
                              builder: (BuildContext context) => ConfirmBook(
                                startpoint: start,
                                destinationpoint: destination,
                                starttime: startTime,
                                finishtime: finishTime,
                                pricing: price,
                                selectedclass: selectedClass,
                                selectedate: selectedDate,
                                cfrom: afrom,
                                cto: ato,
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
