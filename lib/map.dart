// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

// class MapScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     MapController mapController = MapController(
//       initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
//       areaLimit: BoundingBox(
//         east: 10.4922941,
//         north: 47.8084648,
//         south: 45.817995,
//         west: 5.9559113,
//       ),
//     );

//     void _showBottomSheet(BuildContext context) {
//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         builder: (context) {
//           return DraggableScrollableSheet(
//             expand: false,
//             initialChildSize: 0.3,
//             minChildSize: 0.3,
//             maxChildSize: 0.3,
//             builder: (context, scrollController) {
//               return Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[900],
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Column(
//                   children: [
//                     Center(
//                       child: Container(
//                         width: 50,
//                         height: 5,
//                         decoration: BoxDecoration(
//                           color: Colors.grey,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Options',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 20),
//                     ListTile(
//                       leading: Icon(Icons.directions_car, color: Colors.white),
//                       title: Text('Reserve a Spot', style: TextStyle(color: Colors.white)),
//                       onTap: () {
//                         // Handle reserve a spot action
//                       },
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.location_on, color: Colors.white),
//                       title: Text('Mark Coordinates', style: TextStyle(color: Colors.white)),
//                       onTap: () {
//                         // Handle mark coordinates action
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       );
//     }

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
//       body: OSMFlutter(
//         controller: mapController,
//         osmOption: OSMOption(
//           userTrackingOption: const UserTrackingOption(
//             enableTracking: true,
//             unFollowUser: false,
//           ),
//           zoomOption: const ZoomOption(
//             initZoom: 8,
//             minZoomLevel: 3,
//             maxZoomLevel: 19,
//             stepZoom: 1.0,
//           ),
//           userLocationMarker: UserLocationMaker(
//             personMarker: const MarkerIcon(
//               icon: Icon(
//                 Icons.location_history_rounded,
//                 color: Colors.red,
//                 size: 48,
//               ),
//             ),
//             directionArrowMarker: const MarkerIcon(
//               icon: Icon(
//                 Icons.double_arrow,
//                 size: 48,
//               ),
//             ),
//           ),
//           roadConfiguration: const RoadOption(
//             roadColor: Colors.yellowAccent,
//           ),
//           markerOption: MarkerOption(
//             defaultMarker: const MarkerIcon(
//               icon: Icon(
//                 Icons.local_parking,
//                 color: Colors.blue,
//                 size: 56,
//               ),
//             ),
//           ),
//         ),
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


import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  GeoPoint? currentLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestLocationPermission();
    });
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
      GeoPoint position = await mapController.myLocation();
      print('Current location: $position');
      setState(() {
        currentLocation = position;
      });
    } catch (e) {
      print('Error getting location: $e');
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
          OSMFlutter(
            controller: mapController,
            osmOption: OSMOption(
              userTrackingOption: const UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: const ZoomOption(
                initZoom: 8,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
              roadConfiguration: const RoadOption(
                roadColor: Colors.yellowAccent,
              ),
              markerOption: MarkerOption(
                defaultMarker: const MarkerIcon(
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


