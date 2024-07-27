// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FastagSignIn extends StatefulWidget {
//   @override
//   _FastagSignInState createState() => _FastagSignInState();
// }

// class _FastagSignInState extends State<FastagSignIn> {
//   final _phoneController = TextEditingController();
//   final _vehicleController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   String? _errorMessage;

//   Future<void> _connectFastag() async {
//     if (_phoneController.text.isEmpty || _vehicleController.text.isEmpty) {
//       setState(() {
//         _errorMessage = "All fields are required";
//       });
//       return;
//     }

//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await _firestore.collection('users').doc(user.uid).update({
//           'phone_number': _phoneController.text,
//           'vehicle_number': _vehicleController.text,
//         });
//         Navigator.pushReplacementNamed(context, '/connection');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Connect Fastag',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Serif',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 if (_errorMessage != null)
//                   Text(
//                     _errorMessage!,
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 SizedBox(height: 20),
//                 _buildTextField(_phoneController, 'your phone number', false),
//                 SizedBox(height: 20),
//                 _buildTextField(_vehicleController, 'your vehicle number', false),
//                 SizedBox(height: 40),
//                 ElevatedButton(
//                   onPressed: _connectFastag,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[850],
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                     child: Text(
//                       'Connect',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String hintText, bool obscureText) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       style: TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(color: Colors.grey),
//         filled: true,
//         fillColor: Colors.grey[800],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30.0),
//           borderSide: BorderSide.none,
//         ),
//         suffixIcon: Icon(
//           Icons.arrow_forward,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }


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

  Future<void> _saveFastagInfo() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'fastag_info': _fastagController.text,
        }, SetOptions(merge: true)); // Using set with merge option

        print('Fastag info saved successfully');
        // Navigate to the home screen or wherever you need to go
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
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enter Fastag Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(_fastagController, 'Enter Fastag ID', false),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _saveFastagInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[850], // background color
                    foregroundColor: Colors.white, // text color
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


