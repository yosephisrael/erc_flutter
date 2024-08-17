//import 'package:firebase_auth/firebase_auth.dart';
///import 'package:erbs/Users/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbs/Users/availableJourney.dart';
import 'package:erbs/Users/book.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:erbs/Users/payLater.dart';
import 'package:erbs/Users/roundAvailableJourney.dart';
import 'package:erbs/Users/updateBooked.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// void signUserOut() {
//   FirebaseAuth.instance.signOut();
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       appBar: AppBar(
//         actions: [
//           const IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
//         ],
//       ),
//       body: const Center(
//         child: Text('Home Page'),
//       ));
// }

// ignore: must_be_immutable, use_key_in_widget_constructors

class BookRoundPage extends StatefulWidget {
  final String? from;
  final String? to;
  const BookRoundPage({Key? key, this.from, this.to}) : super(key: key);
  @override
  _BookRoundPageState createState() => _BookRoundPageState();
}

class _BookRoundPageState extends State<BookRoundPage> {
  int selectedPassengerCount = 1; // Initialize the variable

  final List<String> items = ['Hard Seat', 'Hard Berth', 'Soft Berth'];
  String? dropdownValue;

  TextEditingController _journeyDateController = TextEditingController();
  TextEditingController _returnDateController = TextEditingController();

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  int _selectedIndex = 1; // Define _selectedIndex variable here

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
        break;
      case 2:
        // Navigate to update booking screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BottomManagePaidJourney(
              pfrom: _fromController.text,
              pto: _toController.text,
            ),
          ),
        );
        break;
      case 3:
        // Navigate to payment later screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => PaymentLater(
              pfrom: _fromController.text,
              pto: _toController.text,
            ),
          ),
        );
        break;
    }
  }

  final List<String> cities = [
    'Addis Ababa',
    'Adama',
    'Bishoftu',
    'Mojo',
    'Mieso',
    'Bike',
    'Dire Dawa'
  ];

  @override
  void initState() {
    super.initState();
    _fromController.text = widget.from!;
    _toController.text = widget.to!;
    selectedPassengerCount = 1;
  }

  Widget buildCityListDialog(TextEditingController controller) {
    double dialogWidth =
        MediaQuery.of(context).size.width * 0.8; // Adjust the width as needed
    double dialogHeight = MediaQuery.of(context).size.height * 0.3;
    double itemHeight =
        50.0; // Adjust this value according to your ListTile height
    int itemCount = cities.length;
    double maxHeight = itemHeight * itemCount;
    double listViewHeight = dialogHeight > maxHeight ? maxHeight : dialogHeight;

    return Dialog(
      elevation: 0, // Set to 0 to remove default dialog shadow
      backgroundColor:
          Colors.transparent, // Set background color to transparent
      child: Material(
        elevation: 10, // Add elevation for box shadow
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xFF3F7347),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: dialogWidth, // Set the width of the dialog
          height: listViewHeight +
              30, // Adding extra space for the header and padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select City',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'DMSans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable list scrolling
                        itemCount: cities.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              cities[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'DMSans',
                                fontSize: 15.0,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                controller.text = cities[index];
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book a Journey',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: 'One Way',
                      isSelected: false,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => BookPage(
                                    from: _fromController.text,
                                    to: _toController.text,
                                  )),
                        );
                        // Action when One Way button is pressed
                      },
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    CustomButton(
                      text: 'Round Journey',
                      isSelected: true,
                      onPressed: () {
                        // Action when Round Journey button is pressed
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 85,
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          readOnly: true,
                          controller: _journeyDateController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3F7347),
                              ),
                            ),
                            hintText: 'Journey Date',
                            hintStyle: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'DMSans',
                                color: Colors.grey),
                            prefixIcon: const Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onTap: () async {
                            DateTime tomorrow =
                                DateTime.now().add(const Duration(days: 1));
                            DateTime fourthDay = tomorrow.add(const Duration(
                                days:
                                    4)); // Calculate the fifth day from tomorrow

                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: tomorrow,
                              firstDate: tomorrow,
                              lastDate:
                                  fourthDay, // Set the last selectable date to be the fifth day from tomorrow
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.dark().copyWith(
                                    // Customize the theme
                                    colorScheme: ColorScheme.dark(
                                      primary: const Color(
                                          0xFF3F7347), // Customize primary color
                                      onPrimary:
                                          Colors.white, // Customize text color
                                      surface: Colors.grey
                                          .shade200, // Customize background color
                                      onSurface:
                                          Colors.black, // Customize text color
                                    ),
                                    dialogBackgroundColor: const Color(
                                        0xFF3F7347), // Customize dialog background color
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (selectedDate != null) {
                              // Format the selected date as dd/mm/yy
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);

                              // Update the text field with the selected date
                              _journeyDateController.text = formattedDate;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 16), // Adjust the spacing between the containers
                  Expanded(
                    child: Container(
                      height: 85,
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          readOnly: true,
                          controller: _returnDateController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3F7347),
                              ),
                            ),
                            hintText: 'Return Date',
                            hintStyle: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'DMSans',
                                color: Colors.grey),
                            prefixIcon: const Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onTap: () async {
                            DateTime tomorrow =
                                DateTime.now().add(const Duration(days: 1));
                            DateTime fourthDay = tomorrow.add(const Duration(
                                days:
                                    4)); // Calculate the fifth day from tomorrow

                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: tomorrow,
                              firstDate: tomorrow,
                              lastDate:
                                  fourthDay, // Set the last selectable date to be the fifth day from tomorrow
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.dark().copyWith(
                                    // Customize the theme
                                    colorScheme: ColorScheme.dark(
                                      primary: const Color(
                                          0xFF3F7347), // Customize primary color
                                      onPrimary:
                                          Colors.white, // Customize text color
                                      surface: Colors.grey
                                          .shade200, // Customize background color
                                      onSurface:
                                          Colors.black, // Customize text color
                                    ),
                                    dialogBackgroundColor: const Color(
                                        0xFF3F7347), // Customize dialog background color
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (selectedDate != null) {
                              // Format the selected date as dd/mm/yy
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);

                              // Update the text field with the selected date
                              _returnDateController.text = formattedDate;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Third container with search boxes and button
              Container(
                height:
                    118, // Adjust the height of the container holding text fields and button
                width: MediaQuery.of(context)
                    .size
                    .width, // Adjust the width to match the screen width
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(
                          0, 2), // This is the shadow direction, only downward
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    buildCityListDialog(_fromController),
                              );
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _fromController,
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: 'DMSans'),
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF3F7347)),
                                  ),
                                  hintText: 'From',
                                  hintStyle: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'DMSans',
                                      color: Colors.grey),
                                  prefixIcon: const Icon(Icons.train,
                                      color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF3F7347)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz),
                          onPressed: () {
                            String temp = _fromController.text;
                            _fromController.text = _toController.text;
                            _toController.text = temp;
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    buildCityListDialog(_toController),
                              );
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _toController,
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: 'DMSans'),
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF3F7347)),
                                  ),
                                  hintText: 'To',
                                  hintStyle: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'DMSans',
                                      color: Colors.grey),
                                  prefixIcon: const Icon(Icons.train,
                                      color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF3F7347)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'No of Passengers',
                      style: TextStyle(fontSize: 15, fontFamily: 'DMSans'),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Adjust alignment
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_left),
                                onPressed: () {
                                  setState(() {
                                    if (selectedPassengerCount > 1) {
                                      selectedPassengerCount -= 1;
                                    }
                                  });
                                },
                              ),
                              Text(
                                selectedPassengerCount.toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_right),
                                onPressed: () {
                                  setState(() {
                                    if (selectedPassengerCount < 5) {
                                      selectedPassengerCount += 1;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 60),
                        Theme(
                          data: Theme.of(context).copyWith(
                            // Customize dropdown item color after selection
                            colorScheme: ColorScheme.fromSwatch().copyWith(
                              secondary: Colors.black,
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: items
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            // underline: Container(), // Remove default underline
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'DMSans',
                              fontSize: 17,
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            isExpanded: false,
                            dropdownColor: Colors.grey.shade200,
                            itemHeight:
                                50, // Adjust the height of the dropdown item
                            hint: const Text(
                              'Select Class', // Add hint text for the second dropdown
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_journeyDateController.text.isEmpty) {
                      // Show error message if date is not selected
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 10,
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Date is Empty',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            content: const Text(
                              'Please select a date for the journey.',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'DMSans',
                              ),
                            ),
                            backgroundColor: const Color(0xFF3F7347),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
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
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      return; // Exit the onPressed function if the date controller is empty
                    }
                    // Check if the journey date is even
                    bool isEvenJourneyDate =
                        int.parse(_journeyDateController.text.split('-')[2]) %
                                2 ==
                            0;

                    // Check if the return date is even
                    bool isEvenReturnDate =
                        int.parse(_returnDateController.text.split('-')[2]) %
                                2 ==
                            0;

                    // Check if both journey and return dates have the same parity
                    if (isEvenJourneyDate == isEvenReturnDate) {
                      // Show dialog for invalid date pair
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Invalid Date Pair',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF3F7347),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Color(0xFF3F7347)),
                            ),
                            content: const Text(
                              'Please select odd and even day pairs.',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'DMSans',
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Proceed with other validations
                      String fromCity = _fromController.text.toLowerCase();
                      String toCity = _toController.text.toLowerCase();

                      if (_fromController.text == _toController.text) {
                        // Show dialog if 'From' and 'To' cities are the same
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              elevation: 10,
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Change Cities',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Same city cannot be start and destination. Please retry.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'DMSans',
                                ),
                              ),
                              backgroundColor: const Color(0xFF3F7347),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side:
                                    const BorderSide(color: Color(0xFF3F7347)),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (dropdownValue == null) {
                        // Show error message if class is not selected
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              elevation: 10,
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Class is Not Selected',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Please select a class for the journey.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'DMSans',
                                ),
                              ),
                              backgroundColor: const Color(0xFF3F7347),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side:
                                    const BorderSide(color: Color(0xFF3F7347)),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if ((isEvenJourneyDate &&
                              (fromCity == 'addis ababa' ||
                                  fromCity == 'adama') &&
                              (toCity == 'adama' || toCity == 'dire dawa')) ||
                          (!isEvenJourneyDate &&
                              (fromCity == 'adama' ||
                                  fromCity == 'dire dawa') &&
                              (toCity == 'addis ababa' || toCity == 'adama'))) {
                        // Show dialog for no available journey
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'No Journey Available',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: const Color(0xFF3F7347),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side:
                                    const BorderSide(color: Color(0xFF3F7347)),
                              ),
                              content: const Text(
                                'No journey available for the selected cities and date.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'DMSans',
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Perform the search operation
                        String selectedDate = _journeyDateController.text;
                        String selectedReturnDate = _returnDateController.text;

// Convert the selected date to the required format
                        String formattedDate = DateFormat('E, MMM d').format(
                            DateTime.parse(DateFormat('yyyy-MM-dd')
                                .parse(selectedDate)
                                .toString()));
                        String formattedReturnDate = DateFormat('E, MMM dd')
                            .format(DateTime.parse(DateFormat('yyyy-MM-dd')
                                .parse(selectedReturnDate)
                                .toString()));

                        var query = FirebaseFirestore.instance
                            .collection('Fares')
                            .where('start', isEqualTo: _fromController.text)
                            .where('destination', isEqualTo: _toController.text)
                            .where('class', isEqualTo: dropdownValue);

// Perform the query
                        var querySnapshot = await query.get();

                        var queryReverse = FirebaseFirestore.instance
                            .collection('Fares')
                            .where('start', isEqualTo: _toController.text)
                            .where('destination',
                                isEqualTo: _fromController.text)
                            .where('class', isEqualTo: dropdownValue);

// Perform the reverse query
                        var reverseSnapshot = await queryReverse.get();

                        if (querySnapshot.docs.isNotEmpty &&
                            reverseSnapshot.docs.isNotEmpty) {
                          // Documents found, display the details
                          var data = querySnapshot.docs[0].data();
                          var reverseData = reverseSnapshot.docs[0].data();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RoundJourneyScreen(
                                start: data['start'],
                                destination: data['destination'],
                                startTime: data['starttime'],
                                finishTime: data['finishtime'],
                                price: data['price'],
                                selectedClass: data['class'],
                                selectedDate: formattedDate,
                                selectedReturnDate: formattedReturnDate,
                                returnstartPoint: reverseData['destination'],
                                returndestinationPoint: reverseData['start'],
                                returnStarttime: reverseData['finishtime'],
                                returnFinishtime: reverseData['starttime'],
                                rafrom: _fromController.text,
                                rato: _toController.text,
                              ),
                            ),
                          );
                        } else {
                          // No documents found, show a message
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'No Journey Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF3F7347),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(
                                      color: Color(0xFF3F7347)),
                                ),
                                content: const Text(
                                  'No journey available for the selected cities and date.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'DMSans',
                                  ),
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
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F7347),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    elevation: 10,
                    minimumSize: const Size(100, 50),
                  ),
                  child: const Text('Search Journey',
                      style: TextStyle(fontSize: 18, fontFamily: 'DMSans')),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin:
            const EdgeInsets.only(bottom: 20.0), // Adjust the value as needed
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
}

class CustomButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {});
        widget.onPressed();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: widget.isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: widget.isSelected
            ? const Color(0xFF3F7347)
            : const Color(0xffededed),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: widget.isSelected ? Colors.grey.shade200 : Colors.white,
          ),
        ),
        elevation: widget.isSelected ? 10 : 0,
      ),
      child: Text(
        widget.text,
        style: TextStyle(
            fontSize: widget.isSelected ? 16 : 14,
            fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
            fontFamily: 'DMsans'),
      ),
    );
  }
}
