// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   String? _errorMessage;

//   Future<void> _signUpWithEmail() async {
//     if (_passwordController.text != _confirmPasswordController.text) {
//       setState(() {
//         _errorMessage = "Passwords do not match";
//       });
//       return;
//     }

//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       // Navigate to the home screen after successful sign-up
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _errorMessage = e.message;
//       });
//     }
//   }

//   Future<void> _signUpWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await _auth.signInWithCredential(credential);
//       // Navigate to the home screen after successful sign-up
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
//                   'Sign up',
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
//                 SizedBox(height: 20),
//                 _buildTextField(_confirmPasswordController, 'confirm password', true),
//                 SizedBox(height: 40),
//                 ElevatedButton(
//                   onPressed: _signUpWithEmail,
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
//                       'Create account',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _signUpWithGoogle,
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
//                       'Sign up with Google',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, '/signin');
//                   },
//                   child: Text(
//                     'already have an account?',
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

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _errorMessage;

  Future<void> _signUpWithEmail() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match";
      });
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Store additional user information in Firestore
      User? user = userCredential.user;
      await _firestore.collection('users').doc(user!.uid).set({
        'email': user.email,
        'created_at': Timestamp.now(),
      });

      // Navigate to the fastag sign-in screen after successful sign-up
      Navigator.pushReplacementNamed(context, '/fastag_signin');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  Future<void> _signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Store additional user information in Firestore
      User? user = userCredential.user;
      await _firestore.collection('users').doc(user!.uid).set({
        'email': user.email,
        'created_at': Timestamp.now(),
      });

      // Navigate to the fastag sign-in screen after successful sign-up
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
                  'Sign up',
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
                _buildTextField(
                    _emailController, 'your email here@gmail.com', false),
                SizedBox(height: 20),
                _buildTextField(
                    _passwordController, 'your password here', true),
                SizedBox(height: 20),
                _buildTextField(
                    _confirmPasswordController, 'confirm password', true),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _signUpWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[850], // background color
                    foregroundColor: Colors.white, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    child: Text(
                      'Create account',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signUpWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[850], // background color
                    foregroundColor: Colors.white, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    child: Text(
                      'Sign up with Google',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  child: Text(
                    'already have an account?',
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

  Widget _buildTextField(
      TextEditingController controller, String hintText, bool obscureText) {
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
