import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:erbs/Users/needed.dart';
import 'package:erbs/Users/settings.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  // Define a list of image paths
  List<Needed> imagePaths = [
    Needed('images/ERD.png'),
    Needed('images/EDR2.png'),
    Needed('images/RAILWAY.png'),
    Needed('images/sheger.png'),
    Needed('images/dire.png'),
    Needed(
      'images/adama.png',
    ),
  ];

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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => Setting(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                const Text(
                  'About Us',
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 50),
          SizedBox(
            height: 250,
            child: ScrollSnapList(
              itemBuilder: _buildListItem,
              itemCount: imagePaths.length,
              itemSize: 200,
              onItemFocus: (index) {},
              dynamicItemSize: true,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(12.0),
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
                    'Ethiopian Railway Corporation.',
                    style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'The Ethiopian Railways Corporation (ERC) was established on 20 November 2007 by regulation 141/2007 of the Council of Ministers of the Federal Democratic Republic of Ethiopia. The regulation mandates ERC to develop railway infrastructure and provide passenger and freight rail transportation services in Ethiopia.'
                    'ERC has developed railway projects on eight corridors in the country that have been identified as necessary to enhance both the social and economic needs.\n\n',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 15,
                      color: Colors.black,
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

  Widget _buildListItem(BuildContext context, int index) {
    Needed product = imagePaths[index];
    double borderRadius = 20.0; // Adjust the border radius as needed

    return SizedBox(
      width: 200,
      height: 100,
      child: ClipPath(
        clipper: FourSidesClipper(borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              product.imagePath,
              fit: BoxFit.cover,
            ),
            // Card(
            //   elevation: 12,
            //   shadowColor: Colors.black.withOpacity(0.5),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(borderRadius),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class FourSidesClipper extends CustomClipper<Path> {
  final double borderRadius;

  FourSidesClipper(this.borderRadius);

  @override
  Path getClip(Size size) {
    Path path = Path();

    double radiusX = borderRadius * 2;
    double radiusY = borderRadius;

    path.moveTo(size.width / 2 + radiusX, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(
        size.width, 0, size.width, borderRadius); // top right corner
    path.lineTo(size.width, size.height - radiusY);
    path.quadraticBezierTo(size.width, size.height, size.width - borderRadius,
        size.height); // bottom right corner
    path.lineTo(borderRadius, size.height);
    path.quadraticBezierTo(
        0, size.height, 0, size.height - radiusY); // bottom left corner
    path.lineTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0); // top left corner

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
