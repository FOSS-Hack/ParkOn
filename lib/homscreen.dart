// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool _isFindingParking = false;
//   bool _parkingFound = false;
//   bool _isFindingRoute = false;
//   bool _showMap = false;

//   MapController mapController = MapController(
//     initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
//     areaLimit: BoundingBox(
//       east: 10.4922941,
//       north: 47.8084648,
//       south: 45.817995,
//       west: 5.9559113,
//     ),
//   );

//   void _findParkingSpot() async {
//     setState(() {
//       _isFindingParking = true;
//     });

//     // Simulate finding a parking spot
//     await Future.delayed(Duration(seconds: 3));

//     setState(() {
//       _parkingFound = true;
//       _isFindingParking = false;
//       _isFindingRoute = true;
//     });

//     // Simulate finding an optimal route
//     await Future.delayed(Duration(seconds: 3));

//     setState(() {
//       _isFindingRoute = false;
//       _showMap = true; // Show the map after finding the route
//     });
//   }

//   void _cancelFindingRoute() {
//     setState(() {
//       _isFindingRoute = false;
//       _parkingFound = false;
//     });
//   }

//   void _signOut() async {
//     try {
//       print('Signing out...');
//       await FirebaseAuth.instance.signOut();
//       print('Signed out successfully');
//       Navigator.pushReplacementNamed(context, '/signup');
//     } catch (e) {
//       print('Error signing out: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error signing out. Please try again.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Park.io',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings, color: Colors.white),
//             onPressed: () {
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.logout, color: Colors.white),
//             onPressed: _signOut,
//           ),
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: _showMap
//               ? OSMFlutter(
//                   controller: mapController,
//                   osmOption: OSMOption(
//                     userTrackingOption: const UserTrackingOption(
//                       enableTracking: true,
//                       unFollowUser: false,
//                     ),
//                     zoomOption: const ZoomOption(
//                       initZoom: 8,
//                       minZoomLevel: 3,
//                       maxZoomLevel: 19,
//                       stepZoom: 1.0,
//                     ),
//                     userLocationMarker: UserLocationMaker(
//                       personMarker: const MarkerIcon(
//                         icon: Icon(
//                           Icons.location_history_rounded,
//                           color: Colors.red,
//                           size: 48,
//                         ),
//                       ),
//                       directionArrowMarker: const MarkerIcon(
//                         icon: Icon(
//                           Icons.double_arrow,
//                           size: 48,
//                         ),
//                       ),
//                     ),
//                     roadConfiguration: const RoadOption(
//                       roadColor: Colors.yellowAccent,
//                     ),
//                     markerOption: MarkerOption(
//                       defaultMarker: const MarkerIcon(
//                         icon: Icon(
//                           Icons.local_parking,
//                           color: Colors.blue,
//                           size: 56,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               : _isFindingParking
//                   ? CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     )
//                   : _parkingFound
//                       ? _isFindingRoute
//                           ? Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.local_parking,
//                                   color: Colors.white,
//                                   size: 80,
//                                 ),
//                                 SizedBox(height: 20),
//                                 Text(
//                                   'Found Parking',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Serif',
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 LinearProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
//                                   backgroundColor: Colors.white,
//                                 ),
//                                 SizedBox(height: 20),
//                                 Text(
//                                   'Finding optimal route',
//                                   style: TextStyle(
//                                     color: Colors.purpleAccent,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 ElevatedButton(
//                                   onPressed: _cancelFindingRoute,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Color.fromARGB(255, 133, 126, 125), // background color
//                                     foregroundColor: Colors.white, // text color
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(30.0),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                                   ),
//                                   child: Text(
//                                     'Cancel',
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.local_parking,
//                                   color: Colors.white,
//                                   size: 80,
//                                 ),
//                                 SizedBox(height: 20),
//                                 Text(
//                                   'Parking Found',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Serif',
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 ElevatedButton(
//                                   onPressed: _findParkingSpot,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.grey[850], // background color
//                                     foregroundColor: Colors.white, // text color
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(30.0),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                                   ),
//                                   child: Text(
//                                     'Find Parking Spot',
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
//                               ],
//                             )
//                       : ElevatedButton(
//                           onPressed: _findParkingSpot,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.grey[850], // background color
//                             foregroundColor: Colors.white, // text color
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30.0),
//                             ),
//                             padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                           ),
//                           child: Text(
//                             'Find Parking Spot',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'map.dart'; // Import the new map screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFindingParking = false;
  bool _parkingFound = false;
  bool _isFindingRoute = false;

  MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  void _findParkingSpot() async {
    setState(() {
      _isFindingParking = true;
    });

    // Simulate finding a parking spot
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _parkingFound = true;
      _isFindingParking = false;
      _isFindingRoute = true;
    });

    // Simulate finding an optimal route
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isFindingRoute = false;
    });

    // Navigate to the map screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
  }

  void _cancelFindingRoute() {
    setState(() {
      _isFindingRoute = false;
      _parkingFound = false;
    });
  }

  void _signOut() async {
    try {
      print('Signing out...');
      await FirebaseAuth.instance.signOut();
      print('Signed out successfully');
      Navigator.pushReplacementNamed(context, '/signup');
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Park.io',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isFindingParking
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : _parkingFound
                  ? _isFindingRoute
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_parking,
                              color: Colors.white,
                              size: 80,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Found Parking',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Serif',
                              ),
                            ),
                            SizedBox(height: 20),
                            LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(237, 72, 40, 1)),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Finding optimal route',
                              style: TextStyle(
                                color: Color.fromRGBO(237, 72, 40, 1),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_parking,
                              color: Colors.white,
                              size: 80,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Parking Found',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Serif',
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _findParkingSpot,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[850], // background color
                                foregroundColor: Colors.white, // text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                              ),
                              child: Text(
                                'Find Parking Spot',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                  : ElevatedButton(
                      onPressed: _findParkingSpot,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850], // background color
                        foregroundColor: Colors.white, // text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                      child: Text(
                        'Find Parking Spot',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
        ),
      ),
    );
  }
}


