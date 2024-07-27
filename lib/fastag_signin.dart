import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FastagSignInScreen extends StatefulWidget {
  @override
  _FastagSignInScreenState createState() => _FastagSignInScreenState();
}

class _FastagSignInScreenState extends State<FastagSignInScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _fastagController = TextEditingController();
  String? _errorMessage;

  bool detectFastagId(String text) {
    final pattern = RegExp(r'^[A-Z0-9]{16}$');
    return pattern.hasMatch(text);
  }

  Future<void> _saveFastagInfo() async {
    String fastagId = _fastagController.text;

    if (!detectFastagId(fastagId)) {
      setState(() {
        _errorMessage = "Invalid Fastag ID. It must be a 16-character alphanumeric string.";
      });
      return;
    }

    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'fastag_info': fastagId,
        }, SetOptions(merge: true)); // Using set with merge option

        print('Fastag info saved successfully');
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        print('Error saving Fastag info: $e');
      }
    } else {
      print('User is not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 31, 32, 0.5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Fastag Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),
                _buildTextField(_fastagController, 'Enter Fastag ID', false),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _saveFastagInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // background color
                    foregroundColor: Colors.black, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Text(
                      'Save Fastag Info',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }
}





