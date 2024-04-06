import 'package:flutter/material.dart';
import 'package:hostel_client/common/dashboardBox.dart';
import 'package:hostel_client/common/navigate.dart';
import 'package:hostel_client/pages/android_app/mappage.dart';

class MainPageParent extends StatefulWidget{
  const MainPageParent({super.key});

  @override
  State<StatefulWidget> createState() => MainPageParentState();
}

class MainPageParentState extends State<MainPageParent>{
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
                  title: 'View ward Location',
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