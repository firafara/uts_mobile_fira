import 'package:flutter/material.dart';
import 'package:project_uts/login/login_page.dart';

class Intro03 extends StatelessWidget {
  const Intro03({super.key});

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
                  "Jawa Tengah Culture",
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Mulai petualangan Anda untuk menjelajahi dan menghargai \nkeberagaman budaya yang kaya di Indonesia",
                  textAlign: TextAlign.center,
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
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF915D2D),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Jost'
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF915D2D),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
