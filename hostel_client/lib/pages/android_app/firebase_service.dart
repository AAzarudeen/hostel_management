import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

class FirestoreService extends StatefulWidget {
  const FirestoreService({super.key});

  @override
  _FirestoreServiceState createState() => _FirestoreServiceState();
}

class _FirestoreServiceState extends State<FirestoreService> {
  bool status = false;
  bool isServiceRunning = false;
  final service = FlutterBackgroundService();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('status')
        .doc('status_doc')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      setState(() {
        // status = snapshot.data()?['status'];
      });
    });
    if (DateTime.now().hour >= 21 || DateTime.now().hour < 5) {
      startBackgroundService();
    }
  }
  onStart() {

      Timer.periodic(Duration(seconds: 10), (timer) {
        updateLocation(timer);
      });
      }

  void startBackgroundService() async {
    print("hi");
    if (!(await service.isRunning())) {
      await service.startService();
      await service.configure(iosConfiguration: IosConfiguration(),
          androidConfiguration: AndroidConfiguration(
            // this will be executed when app is in foreground or background in separated isolate
            autoStart: true,

            // auto start service
            onStart:onStart(),
            isForegroundMode: false,
            notificationChannelId: "notificationChannelId",
            initialNotificationTitle: 'AWESOME SERVICE',
            initialNotificationContent: 'Initializing',
          ));
      setState(() {
        isServiceRunning = true;
      });
    }
  }


  void updateLocation(timer) async{
    try {
      if (DateTime.now().hour >= 21 || DateTime.now().hour < 5) {
        await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high).then((value) =>
            FirebaseFirestore.instance.collection('locations').doc('user_location').set(
                {
                  'latitude': value.latitude,
                  'longitude': value.longitude,
                  // Add more location data as needed
                })
        );
      }else{
        timer.cancel();
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Service Demo'),
      ),
      body: Center(
        child: Text('Status: $status\nService Running: $isServiceRunning'),
      ),
    );
  }
}