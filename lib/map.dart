import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      areaLimit: BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west: 5.9559113,
      ),
    );

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
      body: OSMFlutter(
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
    );
  }
}
