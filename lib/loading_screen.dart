import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 31, 32, 0.5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start, // Align widgets to the left
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 150, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontFamily: 'Poppins', // Adjust the font family as per your requirements
                  ),
                ),
                Text(
                  'ParkOn',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins', // Adjust the font family as per your requirements
                  ),
                ),
                SizedBox(height: 20), // Reduced space between lines of text
                Text(
                  'Your Parking Sidekick',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                    fontFamily: 'Roboto', // Adjust the font family as per your requirements
                  ),
                ),
              ],
            ),
          ),
          Spacer(), // Pushes the button to the center of the page
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button background color
                foregroundColor: Colors.white, // Button text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Text(
                  'Get Started',
                  style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'PF',),
      
                ),
              ),
            ),
          ),
          Spacer(), // Ensures the button remains centered vertically
        ],
      ),
    );
  }
}