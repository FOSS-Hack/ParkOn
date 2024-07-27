

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   String? _errorMessage;

//   Future<void> _signInWithEmail() async {
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       // Navigate to the home screen after successful sign-in
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _errorMessage = e.message;
//       });
//     }
//   }

//   Future<void> _signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await _auth.signInWithCredential(credential);
//       // Navigate to the home screen after successful sign-in
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
//                   'Sign in',
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
//                 _buildTextField(_emailController, 'your email here@gmail.com', false),
//                 SizedBox(height: 20),
//                 _buildTextField(_passwordController, 'your password here', true),
//                 SizedBox(height: 40),
//                 ElevatedButton(
//                   onPressed: _signInWithEmail,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[850], // background color
//                     foregroundColor: Colors.white, // text color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                     child: Text(
//                       'Sign in',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _signInWithGoogle,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[850], // background color
//                     foregroundColor: Colors.white, // text color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                     child: Text(
//                       'Sign in with Google',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, '/signup');
//                   },
//                   child: Text(
//                     'new here?',
//                     style: TextStyle(color: Colors.white),
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
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _errorMessage;

  Future<void> _signInWithEmail() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to the fastag sign-in screen after successful sign-in
      Navigator.pushReplacementNamed(context, '/fastag_signin');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Navigate to the fastag sign-in screen after successful sign-in
      Navigator.pushReplacementNamed(context, '/fastag_signin');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
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
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                  ),
                ),
                SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),
                _buildTextField(_emailController, 'your email here@gmail.com', false),
                SizedBox(height: 20),
                _buildTextField(_passwordController, 'your password here', true),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _signInWithEmail,
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
                      'Sign in',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signInWithGoogle,
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
                      'Sign in with Google',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'new here?',
                    style: TextStyle(color: Colors.white),
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

