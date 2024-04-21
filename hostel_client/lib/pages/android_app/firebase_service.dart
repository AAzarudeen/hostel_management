import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
    // FirebaseFirestore.instance.collection('status')
    //     .doc('status_doc')
    //     .snapshots()
    //     .listen((DocumentSnapshot snapshot) {
    //   setState(() {
    //     // status = snapshot.data()?['status'];
    //   });
    // });
    // requestPermissions();
    startBackgroundService();
    // Start the background service
    // FlutterBackgroundService().startService();

    // Schedule the periodic task
    // FlutterBackgroundService().invoke();
  }
  onStart() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      if (status) {
        timer.cancel();
        return;
      }
      updateLocation();
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


  void updateLocation() {
    // Implement location update logic here
    // For example:
    // FirebaseFirestore.instance.collection('locations').doc('user_location').set(
    //     {
    //       'latitude': 0.0,
    //       'longitude': 0.0,
    //       // Add more location data as needed
    //     });
    print("object");
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