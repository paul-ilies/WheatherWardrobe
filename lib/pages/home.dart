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
            var wheatherIcon =
                snapshot.data?.current!.condition!.icon as String;
            var wheatherCondition =
                snapshot.data?.current!.condition!.text as String;
            return SizedBox(
              // color: Colors.blue,
              height: double.infinity,
              width: double.infinity,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/blue-sky.jpg"),
                        fit: BoxFit.cover)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network("https:$wheatherIcon"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          wheatherCondition,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "$temperature °C",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        "$city",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Text("Not found");
        }
      },
    );
  }
}
