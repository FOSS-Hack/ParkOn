import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parkio/fastag_signin.dart';
import 'package:parkio/homescreen.dart';
import 'package:parkio/settings.dart';
import 'loading_screen.dart';
import 'sign_up_screen.dart';
import 'sign_in_screen.dart';
import 'map.dart';
import 'about-us.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Park.io',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingScreen(),
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/signin': (context) => SignInScreen(),
        '/fastag_signin': (context) => FastagSignInScreen(),
        '/home': (context) => HomeScreen(),
        '/settings': (context) => SettingsScreen(),
        '/login': (context) => SignUpScreen(),
        '/homescreen': (context) => HomeScreen(),
        '/map': (context) => MapScreen(),
        '/about-us':(context) =>AboutUsScreen(),
      },
    );
  }
}