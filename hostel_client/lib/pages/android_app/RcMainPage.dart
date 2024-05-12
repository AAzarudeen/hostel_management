import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/common/dashboardBox.dart';
import 'package:hostel_client/common/navigate.dart';
import 'package:hostel_client/pages/android_app/app_login.dart';
import 'package:hostel_client/pages/viewStudents.dart';

class RcMainPage extends StatefulWidget{
  const RcMainPage({super.key});

  @override
  State<StatefulWidget> createState() => RcMainPageState();
}

class RcMainPageState extends State<RcMainPage>{
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
    title: 'View Students List',
    onTap: () {
    navigateToPage(context,const ViewStudent());
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