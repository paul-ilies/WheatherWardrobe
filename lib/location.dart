import 'package:geolocator/geolocator.dart';

Future<Map<String, double>> getLocation() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    double latitude = position.latitude;
    double longitude = position.longitude;

    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  } catch (e) {
    print('Error getting location: $e');
    return {
      'latitude': 0.0,
      'longitude': 0.0,
    };
  }
}
