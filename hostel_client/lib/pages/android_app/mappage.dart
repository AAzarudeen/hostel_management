import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  // @override
  // void initState() {
  //   super.initState();
  //   _sendLocationToFirebase();
  // }
  MapController mapController = MapController();
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    // Start listening to changes in Firestore
    FirebaseFirestore.instance.collection('locations').snapshots().listen((snapshot) {
      setState(() {
        markers = []; // Clear existing markers
        // Iterate through each document in the snapshot
        snapshot.docs.forEach((doc) {
          // Get the location data from the document
          double latitude = doc['latitude'];
          double longitude = doc['longitude'];
          // Create a marker and add it to the list
          markers.add(
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(latitude, longitude),
              child:   const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          );
        });
      });
    });
  }

  Future<void> _sendLocationToFirebase() async {
    Position position = await _determinePosition();
    if (position != null) {
      // _locationRef.push().set({
      //   'latitude': position.latitude,
      //   'longitude': position.longitude,
      //   'timestamp': ServerValue.timestamp,
      // });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    print(await Geolocator.getCurrentPosition());

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    // return FlutterMap(
    //   options: MapOptions(
    //     initialCenter: LatLng(37.7749, -122.4194),
    //     initialZoom: 9.2,
    //   ),
    //   children: [
    //     TileLayer(
    //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    //       userAgentPackageName: 'com.example.app',
    //     ),
    //     MarkerLayer(markers:  [
    //     Marker(
    //     width: 40.0,
    //       height: 40.0,
    // point: const LatLng(37.7749, -122.4194), // coordinates for marker
    // child: Container(
    //   child: Icon(
    //     Icons.location_on,
    //     color: Colors.red,
    //     size: 40.0,
    //   ),
    // ),
    // ),])
    //   ],
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Map'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(markers.first.point.latitude, markers.first.point.longitude),
          initialZoom: 9.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
      MarkerLayer(markers:  markers)],
    ));
  }
  }