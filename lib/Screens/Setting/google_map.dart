import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MyMapWidget extends StatefulWidget {
  @override
  _MyMapWidgetState createState() => _MyMapWidgetState();
}

class _MyMapWidgetState extends State<MyMapWidget> {
  late GoogleMapController mapController;
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    var permissionStatus = await Permission.locationWhenInUse.status;
    if (permissionStatus.isDenied) {
      await Permission.locationWhenInUse.request();
    } else if (permissionStatus.isGranted) {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          // Location service is still not enabled.
          return;
        }
      }

      LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation = locationData;
        _onCameraViewButtonPressed();
        // Set the value of currentLocation here.
      });
    }
  }

  void _onCameraViewButtonPressed() {
    if (currentLocation != null && mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation!.latitude ?? 0.0,
              currentLocation!.longitude ?? 0.0,
            ),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Current Location'),
      //   automaticallyImplyLeading: true, // Show the back button
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context); // Navigate back when the button is pressed
      //     },
      //   ),
      // ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            currentLocation?.latitude ?? 0.0,
            currentLocation?.longitude ?? 0.0,
          ),
          zoom: 13.5,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(
              currentLocation?.latitude ?? 0.0,
              currentLocation?.longitude ?? 0.0,
            ),
          ),
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 40),
        child: FloatingActionButton(
          onPressed: _onCameraViewButtonPressed,
          child: Icon(Icons.location_searching),
        ),
      ),
    );
  }
}
