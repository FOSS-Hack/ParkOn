import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homescreen.dart'; // Make sure you have this import for homescreen

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color.fromRGBO(35, 31, 32, 0.5),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Bytes',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 10),
            TeamMember(
              name: 'Harikumar',
              linkedInUrl: 'https://www.linkedin.com/in/hari-kumar-3b0963283/',
            ),
            TeamMember(
              name: 'Nikhil Parkar',
              linkedInUrl: 'https://www.linkedin.com/in/nikhil-parkar-49b600274/',
            ),
            TeamMember(
              name: 'Omkar Rajurkar',
              linkedInUrl: 'https://www.linkedin.com/in/omkar-rajurkar-777888555000000000/',
            ),
            TeamMember(
              name: 'Dan Mecartin',
              linkedInUrl: 'https://www.linkedin.com/in/mecartindan/',
            ),
            SizedBox(height: 20),
            Text(
              'About ParkOn',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'ParkOn is a project built during FOSS Hack 24. It helps users find the nearest parking location and allows booking and reserving parking spots in advance.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 10),
            FAQItem(
              question: 'What is ParkOn?',
              answer: 'ParkOn is an app that helps you find the nearest parking location and allows you to book and reserve parking spots in advance.',
            ),
            FAQItem(
              question: 'How does ParkOn work?',
              answer: 'Enter your vehicle type and current location, and ParkOn will suggest the nearest parking locations. You can also reserve a spot in advance.',
            ),
            FAQItem(
              question: 'Can I cancel a reservation?',
              answer: 'Yes, you can cancel a reservation through the app before the reservation start time.',
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(35, 31, 32, 0.5),
    );
  }
}

class TeamMember extends StatelessWidget {
  final String name;
  final String linkedInUrl;

  TeamMember({required this.name, required this.linkedInUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _launchURL(linkedInUrl),
        child: Row(
          children: [
            Icon(Icons.person, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Icon(Icons.link, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          SizedBox(height: 5),
          Text(
            answer,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
