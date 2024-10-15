import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hostel_client/common/navigate.dart';
import 'package:hostel_client/pages/android_app/ViewDetail.dart';
import 'package:hostel_client/pages/android_app/mappage.dart';

class ViewAttendance extends StatefulWidget {
  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    StudentTab(),
    const StudentNotTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.input_sharp),
            label: 'Students In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.output_sharp),
            label: 'Students not in',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class StudentTab extends StatefulWidget {
  @override
  _StudentTabState createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    // Get today's date in the format "YYYY-MM-DD"
    String today = DateTime.now().toString().substring(0, 10);
    // String today = "2024-04-16";

    print(today);
    // Query the attendance collection to get today's document key
    DocumentSnapshot attendanceSnapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(today)
        .get();

    if (attendanceSnapshot.exists) {
      // Get the student keys where the attendance status is true
      Map<String, dynamic> data = attendanceSnapshot.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        print(key);
      });
      List<String> present = List<String>.from(data.keys);
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
      body: ListView.builder(
        itemCount: present.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(present[index]),
          );
        },
      ),
    );
  }
}

class StudentNotTab extends StatefulWidget {
  const StudentNotTab({super.key});

  @override
  _StudentNotTabState createState() => _StudentNotTabState();
}

class _StudentNotTabState extends State<StudentNotTab> {
  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    // Get today's date in the format "YYYY-MM-DD"
    String today = DateTime.now().toString().substring(0, 10);
    // String today = "2024-04-16";

    print(today);
    // Query the attendance collection to get today's document key
    DocumentSnapshot attendanceSnapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(today)
        .get();

    QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .get();


    if (attendanceSnapshot.exists) {
      // Get the student keys where the attendance status is true
      Map<String, dynamic> data = attendanceSnapshot.data() as Map<String, dynamic>;
      // data.forEach((key, value) {
      //   print(key);
      // });
      List<String> allStudentKeys =
      studentSnapshot.docs.map((doc) => doc.id).toList();

      allStudentKeys.forEach((element) {
        print(element);
      });

      List<String> present = List<String>.from(data.keys);
      List<String> absent = allStudentKeys
          .where((studentKey) => !present.contains(studentKey))
          .toList();
      // absentStudentKeys.forEach((element) {
      //   print(element);
      // });
      // absent.forEach((element) {
      //   print(element);
      // });
      setState(() {
        this.absent = absent;
      });
    }
  }
  List<String> absent = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: absent.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(absent[index]),
            onTap: (){
              navigateToPage(context,MapPage(studentRoll: absent[index]));
            },
          );
        },
      ),
    );
  }
}