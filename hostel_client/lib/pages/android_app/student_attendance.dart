import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewStudentAttendance extends StatefulWidget {
  final String rollNumber;
  const ViewStudentAttendance({super.key, required this.rollNumber});

  @override
  State<ViewStudentAttendance> createState() => _ViewStudentAttendanceState();
}

class _ViewStudentAttendanceState extends State<ViewStudentAttendance> {
  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    // Query the attendance collection to get today's document key
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> attendanceSnapshot = await firestore
        .collection('attendance')
        .where("2022179036", isEqualTo: true)
        .get();

    if (attendanceSnapshot.docs.isNotEmpty) {
      List<String> present = [];
      attendanceSnapshot.docs.forEach((element) {
        print(element);
        present.add(element.id);
      });

      present.forEach((element) {
        print(element);
      });

      setState(() {
        this.present = present;
      });
    }
  }

  List<String> present = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Attendance"),
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
          child: ListView.builder(
            itemCount: present.length,
            itemBuilder: (context, index) {
              return Center(
                  child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
              ListTile(
              title: Text(present[index]),
              )
              ]))))));
            },
          ),
        ));
  }
}
