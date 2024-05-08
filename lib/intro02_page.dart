import 'package:flutter/material.dart';
import 'package:project_uts/intro03_page.dart';

class Intro02 extends StatelessWidget {
  const Intro02({super.key});

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(4);
    return Scaffold(
      backgroundColor: Color(0xFFFFEFD8),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Beraneka Ragam Budaya",
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Merajut Kekayaan Budaya Jawa Tengah",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Intro03()),
                );
                },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFF915D2D),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 27.3,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: borderRadius,
                    color: Color(0xFF915D2D),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
