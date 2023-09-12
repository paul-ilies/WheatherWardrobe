import 'package:flutter/material.dart';
import 'package:wheather_wardrobe/datamanager.dart';
import 'package:wheather_wardrobe/datamodel.dart';

class Home extends StatelessWidget {
  final DataManager dataManager;

  const Home({Key? key, required this.dataManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherData>(
      future: dataManager.getWeather(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Text("Error: Weather data not available");
        } else {
          if (snapshot.data?.location != null ||
              snapshot.data?.current != null) {
            var temperature = snapshot.data?.current!.tempC?.round();
            var city = snapshot.data?.location!.name;
            return Column(
              children: [
                Text("$temperature °C"),
                Text("$city"),
              ],
            );
          }

          return const Text("Not found");
        }
      },
    );
  }
}
