import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double lat = 0;
  late double long = 0;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    var location = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    lat = location.latitude;
    long = location.longitude;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Latitude: $lat",
          textAlign: TextAlign.left,
        ),
        Text("Longitude: $long", textAlign: TextAlign.left),
      ],
    );
  }
}
