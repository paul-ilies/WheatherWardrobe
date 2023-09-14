import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                      DisplayProducts(
                        currentCondition: wheatherCondition,
                        dataManager: dataManager,
                      )
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

class DisplayProducts extends StatefulWidget {
  final String currentCondition;
  final DataManager dataManager;
  const DisplayProducts(
      {Key? key, required this.currentCondition, required this.dataManager})
      : super(key: key);

  @override
  State<DisplayProducts> createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts> {
  var _products;
  var _conditions;
  late List<dynamic> _data = [];

  Future<String> loadJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<void> fetchConditions() async {
    final String jsonString = await loadJsonFile('assets/conditions.json');
    var data = jsonDecode(jsonString);
    setState(() {
      _conditions = data;
    });
  }

  Future<void> fetchProducts() async {
    final String jsonString = await loadJsonFile('assets/items.json');
    var data = jsonDecode(jsonString);
    setState(() {
      _products = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchConditions();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    String currentCondition = widget.currentCondition;
    List<String> conditions = ["sunny", "rain", "snow", "frozen"];
    if (_products != null && _conditions != null) {
      for (var i = 0; i < conditions.length; i++) {
        if (_conditions[conditions[i]] != null &&
            _conditions[conditions[i]].contains(currentCondition)) {
          setState(() {
            _data = _products[conditions[i]] ?? [];
          });
        }
      }
    }
    if (_data.isNotEmpty) {
      return Container(
        height: 200,
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            var product = _data[index];

            return ListTile(
              title: Text(product["item"]),
            );
          },
        ),
      );
    }
    return const CircularProgressIndicator();
  }
}
