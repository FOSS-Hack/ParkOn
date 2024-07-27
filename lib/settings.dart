// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _licenseController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserProfile();
//   }

//   void _loadUserProfile() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DocumentSnapshot userProfile = await _firestore.collection('users').doc(user.uid).get();
//       if (userProfile.exists) {
//         setState(() {
//           _nameController.text = userProfile['name'];
//           _ageController.text = userProfile['age'].toString();
//           _licenseController.text = userProfile['license'];
//         });
//       }
//     }
//   }

//   void _saveUserProfile() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).update({
//         'name': _nameController.text,
//         'age': int.tryParse(_ageController.text) ?? 0,
//         'license': _licenseController.text,
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white), // White back icon
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text('Settings', style: TextStyle(color: Colors.white)), // White text color
//         backgroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[850],
//                 child: Icon(Icons.person, size: 50, color: Colors.white),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                   labelStyle: TextStyle(color: Colors.white),
//                   filled: true,
//                   fillColor: Colors.grey[850],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//                 style: TextStyle(color: Colors.white),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _ageController,
//                 decoration: InputDecoration(
//                   labelText: 'Age',
//                   labelStyle: TextStyle(color: Colors.white),
//                   filled: true,
//                   fillColor: Colors.grey[850],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//                 style: TextStyle(color: Colors.white),
//                 keyboardType: TextInputType.number,
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _licenseController,
//                 decoration: InputDecoration(
//                   labelText: 'Car License Number',
//                   labelStyle: TextStyle(color: Colors.white),
//                   filled: true,
//                   fillColor: Colors.grey[850],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//                 style: TextStyle(color: Colors.white),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveUserProfile,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey[850], // background color
//                   foregroundColor: Colors.white, // text color
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                   child: Text(
//                     'Save',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Divider(color: Colors.grey),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   await FirebaseAuth.instance.signOut();
//                   Navigator.pushReplacementNamed(context, '/login');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent, // background color
//                   foregroundColor: Colors.white, // text color
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                   child: Text(
//                     'Sign Out',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: Colors.black,
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _fastagController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile = await _firestore.collection('users').doc(user.uid).get();
      if (userProfile.exists) {
        setState(() {
          _nameController.text = userProfile['name'];
          _ageController.text = userProfile['age'].toString();
          _licenseController.text = userProfile['license'];
          _fastagController.text = userProfile['fastag_info'];
        });
      }
    }
  }

  void _saveUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'license': _licenseController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Settings', style: TextStyle(color: Colors.white)), // White text color
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[850],
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _licenseController,
                decoration: InputDecoration(
                  labelText: 'Car License Number',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _fastagController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fastag ID',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUserProfile,
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
                    'Save',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.grey),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // background color
                  foregroundColor: Colors.white, // text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

