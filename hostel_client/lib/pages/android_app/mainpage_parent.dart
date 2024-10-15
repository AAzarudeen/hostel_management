import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/common/dashboardBox.dart';
import 'package:hostel_client/common/navigate.dart';
import 'package:hostel_client/common/toast.dart';
import 'package:hostel_client/pages/android_app/app_login.dart';
import 'package:hostel_client/pages/android_app/mappage.dart';
import 'package:hostel_client/pages/android_app/mess_reduction.dart';
import 'package:hostel_client/pages/android_app/student_attendance.dart';
import 'package:hostel_client/pages/android_app/view_attendance.dart';
import 'package:hostel_client/pages/android_app/view_circular.dart';

class MainPageParent extends StatefulWidget{
  final Map<String, dynamic>? student_details;
  const MainPageParent({super.key, this.student_details});

  @override
  State<StatefulWidget> createState() => MainPageParentState();
}

class MainPageParentState extends State<MainPageParent>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: <Widget>[
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
                  title: 'View ward Location',
                  onTap: () {
                    print(isNightTime());
                    // if (isNightTime()) {
                        navigateToPage(context, MapPage(studentRoll: widget.student_details?['register']));
                    // }else{
                    //   showToast(title: "Not available", message: "Only from 9 pm to 5 am you can see the current location of your ward", context: context);
                    // }
                  },
                ),
                const SizedBox(height: 20),
                DashboardBox(
                  title: 'View Attendance',
                  onTap: () {
                    navigateToPage(context, ViewStudentAttendance(rollNumber: widget.student_details?['register']));
                  },
                ),
                const SizedBox(height: 20),
                DashboardBox(
                  title: 'Notifications/Circulars',
                  onTap: () {
                    navigateToPage(context,const ViewCicular());
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ))));
  }
  bool isNightTime() {
    final currentTime = DateTime.now().toLocal();
    final startNightTime = TimeOfDay(hour: 21, minute: 0); // 9 PM
    final endNightTime = TimeOfDay(hour: 5, minute: 0); // 5 AM

    final currentHour = currentTime.hour;
    final currentMinute = currentTime.minute;

    final startNightDateTime = DateTime(currentTime.year, currentTime.month, currentTime.day, startNightTime.hour, startNightTime.minute);
    final endNightDateTime = DateTime(currentTime.year, currentTime.month, currentTime.day, endNightTime.hour, endNightTime.minute);

    // Check if current time is between 9 PM and midnight (inclusive)
    if (currentHour >= startNightTime.hour && currentHour < 24) {
      return true;
    }
    // Check if current time is between midnight and 5 AM (inclusive)
    else if (currentHour >= 0 && currentHour < endNightTime.hour) {
      return true;
    }
    // Check if current time is exactly midnight
    else if (currentTime == startNightDateTime || currentTime == endNightDateTime) {
      return true;
    }
    return false;
  }
}