import 'package:flutter/material.dart';
import 'package:hostel_client/common/dashboardBox.dart';
import 'package:hostel_client/common/navigate.dart';
import 'package:hostel_client/pages/android_app/mappage.dart';

class MainPageRc extends StatefulWidget{
  const MainPageRc({super.key});
  @override
  State<StatefulWidget> createState() => MainPageRcState();
}

class MainPageRcState extends State<MainPageRc>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashboardBox(
                  title: 'View Student List',
                  onTap: () {
                    navigateToPage(context,const MapPage());
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}