// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   osm.MapController mapController = osm.MapController(
//     initPosition: osm.GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
//     areaLimit: osm.BoundingBox(
//       east: 10.4922941,
//       north: 47.8084648,
//       south: 45.817995,
//       west: 5.9559113,
//     ),
//   );

//   osm.GeoPoint? currentLocation; // Adjusted to match plugin

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       requestLocationPermission();
//     });
//   }

//   Future<void> requestLocationPermission() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       getCurrentLocation();
//     } else {
//       print("Location permission denied");
//     }
//   }

//   Future<void> getCurrentLocation() async {
//     try {
//       osm.GeoPoint position = await mapController.myLocation();
//       print('Current location: $position');

//       setState(() {
//         currentLocation = position;
//       });

//       // Save coordinates to Firestore
//       await saveCoordinatesToFirestore(position);
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }

//   Future<void> saveCoordinatesToFirestore(osm.GeoPoint position) async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//           'lastKnownCoordinates': {
//             'latitude': position.latitude,
//             'longitude': position.longitude,
//           }
//         });
//         print('Coordinates saved to Firestore');
//       }
//     } catch (e) {
//       print('Error saving coordinates to Firestore: $e');
//     }
//   }

//   void _showBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.3,
//           minChildSize: 0.3,
//           maxChildSize: 0.3,
//           builder: (context, scrollController) {
//             return Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 50,
//                       height: 5,
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Options',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   ListTile(
//                     leading: Icon(Icons.directions_car, color: Colors.white),
//                     title: Text('Reserve a Spot', style: TextStyle(color: Colors.white)),
//                     onTap: () {
//                       // Handle reserve a spot action
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.location_on, color: Colors.white),
//                     title: Text('Mark Coordinates', style: TextStyle(color: Colors.white)),
//                     onTap: () {
//                       // Handle mark coordinates action
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Map',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, '/homescreen');
//           },
//         ),
//       ),
//       body: Stack(
//         children: [
//           osm.OSMFlutter(
//             controller: mapController,
//             osmOption: osm.OSMOption(
//               userTrackingOption: const osm.UserTrackingOption(
//                 enableTracking: true,
//                 unFollowUser: false,
//               ),
//               zoomOption: const osm.ZoomOption(
//                 initZoom: 8,
//                 minZoomLevel: 3,
//                 maxZoomLevel: 19,
//                 stepZoom: 1.0,
//               ),
//               userLocationMarker: osm.UserLocationMaker(
//                 personMarker: const osm.MarkerIcon(
//                   icon: Icon(
//                     Icons.location_history_rounded,
//                     color: Colors.red,
//                     size: 48,
//                   ),
//                 ),
//                 directionArrowMarker: const osm.MarkerIcon(
//                   icon: Icon(
//                     Icons.double_arrow,
//                     size: 48,
//                   ),
//                 ),
//               ),
//               roadConfiguration: const osm.RoadOption(
//                 roadColor: Colors.yellowAccent,
//               ),
//               markerOption: osm.MarkerOption(
//                 defaultMarker: const osm.MarkerIcon(
//                   icon: Icon(
//                     Icons.local_parking,
//                     color: Colors.blue,
//                     size: 56,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           if (currentLocation != null)
//             Positioned(
//               top: 10,
//               left: 10,
//               child: Container(
//                 padding: EdgeInsets.all(8),
//                 color: Colors.black.withOpacity(0.5),
//                 child: Text(
//                   'Lat: ${currentLocation!.latitude}, Long: ${currentLocation!.longitude}',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.grey[900],
//         child: IconButton(
//           icon: Icon(Icons.expand_less, color: Colors.white, size: 30),
//           onPressed: () => _showBottomSheet(context),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'dart:math' as math;

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   MapController mapController = MapController(
//     initPosition: GeoPoint(latitude: 12.820511696606678, longitude: 80.22185887503957), // Chennai coordinates
//     areaLimit: BoundingBox(
//       east: 80.25,
//       north: 12.77,
//       south: 12.73,
//       west: 80.15,
//     ),
//   );

//   List<GeoPoint> parkingSpots = [
//     GeoPoint(latitude: 12.754000, longitude: 80.200000), // Example spot 1
//     GeoPoint(latitude: 12.754200, longitude: 80.200300), // Example spot 2
//     GeoPoint(latitude: 12.754400, longitude: 80.200600), // Example spot 3
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _addParkingSpots();
//     });
//   }

//   void _addParkingSpots() {
//     for (var spot in parkingSpots) {
//       mapController.addMarker(spot, markerIcon: MarkerIcon(
//         icon: Icon(
//           Icons.local_parking,
//           color: Colors.blue,
//           size: 48,
//         ),
//       ));
//     }
//   }

//   double _calculateDistance(GeoPoint start, GeoPoint end) {
//     const R = 6371000; // Earth's radius in meters
//     double dLat = (end.latitude - start.latitude) * (math.pi / 180);
//     double dLon = (end.longitude - start.longitude) * (math.pi / 180);
//     double lat1 = start.latitude * (math.pi / 180);
//     double lat2 = end.latitude * (math.pi / 180);

//     double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2);
//     double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

//     return R * c; // Distance in meters
//   }

//   GeoPoint _findNearestParkingSpot(GeoPoint currentLocation) {
//     GeoPoint nearestSpot = parkingSpots[0];
//     double shortestDistance = _calculateDistance(currentLocation, nearestSpot);

//     for (var spot in parkingSpots) {
//       double distance = _calculateDistance(currentLocation, spot);
//       if (distance < shortestDistance) {
//         shortestDistance = distance;
//         nearestSpot = spot;
//       }
//     }
//     return nearestSpot;
//   }

//   void _highlightRoute(GeoPoint start, GeoPoint end) async {
//     await mapController.drawRoad(
//       start,
//       end,
//       roadType: RoadType.car,
//       roadOption: RoadOption(
//         roadColor: Colors.blue,
//         roadWidth: 10,
//       ),
//     );
//   }

//   void _showNearestParkingRoute() {
//     GeoPoint currentLocation = GeoPoint(latitude: 12.820511696606678,  longitude:80.22185887503957);
//     print("Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}");
    
//     GeoPoint nearestSpot = _findNearestParkingSpot(currentLocation);
//     print("Nearest Spot: ${nearestSpot.latitude}, ${nearestSpot.longitude}");
    
//     _highlightRoute(currentLocation, nearestSpot);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Map',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, '/homescreen');
//           },
//         ),
//       ),
//       body: Stack(
//         children: [
//           OSMFlutter(
//             controller: mapController,
//             osmOption: OSMOption(
//               userTrackingOption: const UserTrackingOption(
//                 enableTracking: true,
//                 unFollowUser: false,
//               ),
//               zoomOption: const ZoomOption(
//                 initZoom: 8,
//                 minZoomLevel: 3,
//                 maxZoomLevel: 19,
//                 stepZoom: 1.0,
//               ),
//               userLocationMarker: UserLocationMaker(
//                 personMarker: const MarkerIcon(
//                   icon: Icon(
//                     Icons.location_history_rounded,
//                     color: Colors.red,
//                     size: 48,
//                   ),
//                 ),
//                 directionArrowMarker: const MarkerIcon(
//                   icon: Icon(
//                     Icons.double_arrow,
//                     size: 48,
//                   ),
//                 ),
//               ),
//               roadConfiguration: const RoadOption(
//                 roadColor: Color.fromARGB(255, 237, 6, 6),
//               ),
//               markerOption: MarkerOption(
//                 defaultMarker: const MarkerIcon(
//                   icon: Icon(
//                     Icons.local_parking,
//                     color: Colors.blue,
//                     size: 56,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 10,
//             right: 10,
//             child: FloatingActionButton(
//               onPressed: _showNearestParkingRoute,
//               child: Icon(Icons.directions, color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  osm.MapController mapController = osm.MapController(
    initPosition: osm.GeoPoint(latitude: 12.820511696606678, longitude: 80.22185887503957), // Chennai coordinates
    areaLimit: osm.BoundingBox(
      east: 80.25,
      north: 12.77,
      south: 12.73,
      west: 80.15,
    ),
  );

  List<osm.GeoPoint> parkingSpots = [
    osm.GeoPoint(latitude: 12.754000, longitude: 80.200000), // Example spot 1
    osm.GeoPoint(latitude: 12.754200, longitude: 80.200300), // Example spot 2
    osm.GeoPoint(latitude: 12.754400, longitude: 80.200600), // Example spot 3
  ];

  osm.GeoPoint? currentLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addParkingSpots();
      requestLocationPermission();
    });
  }

  void _addParkingSpots() {
    for (var spot in parkingSpots) {
      mapController.addMarker(spot, markerIcon: osm.MarkerIcon(
        icon: Icon(
          Icons.local_parking,
          color: Colors.blue,
          size: 48,
        ),
      ));
    }
  }

  double _calculateDistance(osm.GeoPoint start, osm.GeoPoint end) {
    const R = 6371000; // Earth's radius in meters
    double dLat = (end.latitude - start.latitude) * (math.pi / 180);
    double dLon = (end.longitude - start.longitude) * (math.pi / 180);
    double lat1 = start.latitude * (math.pi / 180);
    double lat2 = end.latitude * (math.pi / 180);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return R * c; // Distance in meters
  }

  osm.GeoPoint _findNearestParkingSpot(osm.GeoPoint currentLocation) {
    osm.GeoPoint nearestSpot = parkingSpots[0];
    double shortestDistance = _calculateDistance(currentLocation, nearestSpot);

    for (var spot in parkingSpots) {
      double distance = _calculateDistance(currentLocation, spot);
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestSpot = spot;
      }
    }
    return nearestSpot;
  }

  void _highlightRoute(osm.GeoPoint start, osm.GeoPoint end) async {
    await mapController.drawRoad(
      start,
      end,
      roadType: osm.RoadType.car,
      roadOption: osm.RoadOption(
        roadColor: Colors.blue,
        roadWidth: 10,
      ),
    );
  }

  void _showNearestParkingRoute() {
    if (currentLocation != null) {
      print("Current Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}");
      osm.GeoPoint nearestSpot = _findNearestParkingSpot(currentLocation!);
      print("Nearest Spot: ${nearestSpot.latitude}, ${nearestSpot.longitude}");
      _highlightRoute(currentLocation!, nearestSpot);
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      getCurrentLocation();
    } else {
      print("Location permission denied");
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      osm.GeoPoint position = await mapController.myLocation();
      print('Current location: $position');

      setState(() {
        currentLocation = position;
      });

      // Save coordinates to Firestore
      await saveCoordinatesToFirestore(position);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> saveCoordinatesToFirestore(osm.GeoPoint position) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'lastKnownCoordinates': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          }
        });
        print('Coordinates saved to Firestore');
      }
    } catch (e) {
      print('Error saving coordinates to Firestore: $e');
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3,
          minChildSize: 0.3,
          maxChildSize: 0.3,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Options',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.directions_car, color: Colors.white),
                    title: Text('Reserve a Spot', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      // Handle reserve a spot action
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.white),
                    title: Text('Mark Coordinates', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      // Handle mark coordinates action
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Map',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/homescreen');
          },
        ),
      ),
      body: Stack(
        children: [
          osm.OSMFlutter(
            controller: mapController,
            osmOption: osm.OSMOption(
              userTrackingOption: const osm.UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: const osm.ZoomOption(
                initZoom: 8,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: osm.UserLocationMaker(
                personMarker: const osm.MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const osm.MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
              roadConfiguration: const osm.RoadOption(
                roadColor: Colors.yellowAccent,
              ),
              markerOption: osm.MarkerOption(
                defaultMarker: const osm.MarkerIcon(
                  icon: Icon(
                    Icons.local_parking,
                    color: Colors.blue,
                    size: 56,
                  ),
                ),
              ),
            ),
          ),
          if (currentLocation != null)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  'Lat: ${currentLocation!.latitude}, Long: ${currentLocation!.longitude}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _showNearestParkingRoute,
              child: Icon(Icons.directions, color: Colors.black),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: IconButton(
          icon: Icon(Icons.expand_less, color: Colors.white, size: 30),
          onPressed: () => _showBottomSheet(context),
        ),
      ),
    );
  }
}




