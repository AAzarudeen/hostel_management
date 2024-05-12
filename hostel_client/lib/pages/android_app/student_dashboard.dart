import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hostel_client/common/dashboardBox.dart';
import 'package:hostel_client/common/navigate.dart';
import 'package:hostel_client/pages/android_app/ViewDetail.dart';
import 'package:hostel_client/pages/android_app/app_login.dart';
import 'package:hostel_client/pages/android_app/mess_reduction.dart';

class StudentDashboardPage extends StatefulWidget {
  final Map<String, dynamic>? student_details;

  const StudentDashboardPage({super.key, this.student_details});

  @override
  State<StatefulWidget> createState() => StudentDashboardPageState();
}

class StudentDashboardPageState extends State<StudentDashboardPage> {
  bool status = false;
  bool isServiceRunning = false;
  final service = FlutterBackgroundService();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('status')
        .doc('status_doc')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      setState(() {
        // status = snapshot.data()?['status'];
      });
    });
    if (DateTime.now().hour >= 21 || DateTime.now().hour < 5) {
      // startBackgroundService();
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
      await service.configure(
          iosConfiguration: IosConfiguration(),
          androidConfiguration: AndroidConfiguration(
            // this will be executed when app is in foreground or background in separated isolate
            autoStart: true,

            // auto start service
            onStart: onStart(),
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

  void updateLocation(timer) async {
    try {
      if (DateTime.now().hour >= 21 || DateTime.now().hour < 5) {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((value) => FirebaseFirestore.instance
                    .collection('locations')
                    .doc('user_location')
                    .set({
                  'latitude': value.latitude,
                  'longitude': value.longitude,
                  // Add more location data as needed
                }));
      } else {
        timer.cancel();
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              navigateToPage(
                  context,
                  ViewStudentDetails(studentDetails: widget.student_details));
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AppLoginPage()),
              );
            },
          ),
        ],
      ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade600,
                  Colors.blue.shade400,
                ],
              ),
            ),
            child: Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        DashboardBox(
                          title: 'Apply Mess Reduction form',
                          onTap: () {
                            navigateToPage(context,const MessReduction());
                          },
                        ),
                        const SizedBox(height: 20),
                        DashboardBox(
                          title: 'View Attendance',
                          onTap: () {
                            navigateToPage(context,const MessReduction());
                          },
                        ),
                        const SizedBox(height: 20),
                        DashboardBox(
                          title: 'Notifications/Circulars',
                          onTap: () {
                            navigateToPage(context,const MessReduction());
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
            )
        )
    );
  }
}