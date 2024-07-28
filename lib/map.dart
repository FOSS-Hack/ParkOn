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
    initPosition: osm.GeoPoint(latitude: 12.820511696606678, longitude: 80.22185887503957),
    areaLimit: osm.BoundingBox(
      east: 80.25,
      north: 12.77,
      south: 12.73,
      west: 80.15,
    ),
  );

  List<osm.GeoPoint> parkingSpots = [
    osm.GeoPoint(latitude: 12.754000, longitude: 80.200000),
    osm.GeoPoint(latitude: 12.754200, longitude: 80.200300),
    osm.GeoPoint(latitude: 12.754400, longitude: 80.200600),
  ];

  osm.GeoPoint? currentLocation;
  osm.GeoPoint? savedParkingCoordinates;

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
        icon: Icon(Icons.local_parking, color: Colors.blue, size: 48),
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

  Future<void> showReservationForm(BuildContext context) async {
    TextEditingController locationController = TextEditingController();
    DateTime? startTime;
    DateTime? endTime;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Reserve a Parking Spot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      title: Text(
                        startTime == null
                            ? 'Select Start Time'
                            : 'Start Time: ${startTime?.toLocal()}',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            startTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            setState(() {});
                          }
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        endTime == null
                            ? 'Select End Time'
                            : 'End Time: ${endTime?.toLocal()}',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            endTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            setState(() {});
                          }
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (locationController.text.isNotEmpty && startTime != null && endTime != null) {
                          reserveParkingSpot(locationController.text, startTime!, endTime!);
                          Navigator.pop(context);
                        } else {
                          print('Please fill in all fields');
                        }
                      },
                      child: Text('Reserve'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> reserveParkingSpot(String location, DateTime startTime, DateTime endTime) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference parkingSpotDoc = FirebaseFirestore.instance.collection('multistorey').doc(location);

        await parkingSpotDoc.update({
          'StartTime': startTime,
          'EndTime': endTime,
          'ReservationUserId': user.uid,
        });

        // Show a SnackBar with a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Parking spot reserved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        print('Parking spot reserved successfully');
      }
    } catch (e) {
      // Show a SnackBar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error reserving parking spot.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      print('Error reserving parking spot: $e');
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

      await saveCoordinatesToFirestore(position, 'lastKnownCoordinates');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> saveCoordinatesToFirestore(osm.GeoPoint position, String field) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          field: {
            'latitude': position.latitude,
            'longitude': position.longitude,
          }
        });
        print('Coordinates saved to Firestore');
        if (field == 'parkingCoordinates') {
          setState(() {
            savedParkingCoordinates = position;
          });
        }
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
          initialChildSize: 0.4,
          minChildSize: 0.4,
          maxChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Navigator.pop(context);
                      showReservationForm(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.white),
                    title: Text('Mark Parking Coordinates', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      if (currentLocation != null) {
                        saveCoordinatesToFirestore(currentLocation!, 'parkingCoordinates');
                        Navigator.pop(context);
                      } else {
                        print('Current location is not available');
                      }
                    },
                  ),
                  if (savedParkingCoordinates != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: Text(
                          'Last Saved Parking Coordinates:\nLat: ${savedParkingCoordinates!.latitude}, Long: ${savedParkingCoordinates!.longitude}',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
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
