import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  final String studentRoll;
  const MapPage({super.key, required this.studentRoll});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  MapController mapController = MapController();
  List<Marker> markers = [];

  void clearState() {
    setState(() {
      markers = [];
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('locations').doc(widget.studentRoll).snapshots().listen((snapshot) {
      print(widget.studentRoll);
      print(snapshot['latitude']);
      print(snapshot['longitude']);
      setState(() {
        markers = [];
          double latitude = snapshot['latitude'];
          double longitude = snapshot['longitude'];

          markers.add(
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(latitude, longitude),
              child:   const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          );
        });
      mapController.move(LatLng(markers.first.point.latitude, markers.first.point.longitude), 20);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Map'),
      ),
      body: Container(
      child: StreamBuilder(
    stream:
    FirebaseFirestore.instance.collection('students').snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    }
          return FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(markers.first.point.latitude, markers.first.point.longitude),
              initialZoom: 20.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers:  markers)],
          );
    },
      )
      ));
  }
  }