import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class LocationUpdater {
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Method channel for receiving location updates from platform
final MethodChannel _locationChannel =
const MethodChannel('location_channel');

void startLocationUpdates(String rollNumber) {
  print(rollNumber);
  _locationChannel.setMethodCallHandler((call) async {
    if (call.method == 'locationUpdate') {
      Map<String, dynamic> locationData = call.arguments;
      print(rollNumber);
      print(locationData['latitude']);
      print(locationData['longitude']);
      await _storeLocationData(locationData,rollNumber);
    }else{
      print(rollNumber);
    }
  });
  _locationChannel.invokeMethod('startLocationUpdates');
}

Future<void> _storeLocationData(
    Map<String, dynamic> locationData, String rollNumber) async {
  print(rollNumber);
  print(locationData['latitude']);
  print(locationData['longitude']);
  await firestore.collection("locations").doc(rollNumber).set({
    'latitude': locationData['latitude'],
    'longitude': locationData['longitude'],
    'timestamp': DateTime.now(),
  });
}
}
