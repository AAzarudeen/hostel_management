import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // DatabaseReference _locationRef =
  // FirebaseDatabase.instance.reference().child('locations');

  @override
  void initState() {
    super.initState();
    _sendLocationToFirebase();
  }

  Future<void> _sendLocationToFirebase() async {
    Position position = await _determinePosition();
    if (position != null) {
      // _locationRef.push().set({
      //   'latitude': position.latitude,
      //   'longitude': position.longitude,
      //   'timestamp': ServerValue.timestamp,
      // });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    print(await Geolocator.getCurrentPosition());

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(37.7749, -122.4194),
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers:  [
        Marker(
        width: 40.0,
          height: 40.0,
    point: const LatLng(37.7749, -122.4194), // coordinates for marker
    child: Container(
      child: Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40.0,
      ),
    ),
    ),])
      ],
    );
  }
  }