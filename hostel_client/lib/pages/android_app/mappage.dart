// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:firebase_database/firebase_database.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Location Tracker',
//       home: LocationTracker(),
//     );
//   }
// }

// class LocationTracker extends StatefulWidget {
//   @override
//   _LocationTrackerState createState() => _LocationTrackerState();
// }

// class _LocationTrackerState extends State<LocationTracker> {
//   DatabaseReference _locationRef =
//   FirebaseDatabase.instance.reference().child('locations');

//   @override
//   void initState() {
//     super.initState();
//     _sendLocationToFirebase();
//   }

//   Future<void> _sendLocationToFirebase() async {
//     Position position = await _determinePosition();
//     if (position != null) {
//       _locationRef.push().set({
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//         'timestamp': ServerValue.timestamp,
//       });
//     }
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Tracker'),
//       ),
//       body: Center(
//         child: Text('Sending location to Firebase...'),
//       ),
//     );
//   }
// }