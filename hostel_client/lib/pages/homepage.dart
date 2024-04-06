import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/common/dashboardBox.dart';
import 'package:hostel_client/common/navigate.dart';
import 'package:hostel_client/pages/createrc.dart';
import 'package:hostel_client/pages/createstudent.dart';
import 'package:hostel_client/pages/loginpage.dart';
import 'package:hostel_client/pages/viewStudents.dart';

class MyHomePage extends StatefulWidget {
  
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashboardBox(
                  title: 'Create Student',
                  onTap: () {
                    navigateToPage(context,const CreateStudent());
                  },
                ),
                const SizedBox(height: 20),
                DashboardBox(
                  title: 'View Students',
                  onTap: () {
                    navigateToPage(context,const ViewStudent());
                  },
                ),
                const SizedBox(height: 20),
                DashboardBox(
                  title: 'Create RC',
                  onTap: () {
                    navigateToPage(context,const CreateRC());
                  },
                ),
                const SizedBox(height: 20),
                DashboardBox(
                  title: 'Add Notification',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ));
  }
}
