import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/pages/createstudent.dart';
import 'package:hostel_client/pages/loginpage.dart';

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateStudent()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                DashboardBox(
                  title: 'View Students',
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                DashboardBox(
                  title: 'Create Parent',
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                DashboardBox(
                  title: 'Create RC',
                  onTap: () {},
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

class DashboardBox extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DashboardBox({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
