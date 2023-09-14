import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wheather_wardrobe/datamodel.dart';
import 'package:wheather_wardrobe/location.dart';

class DataManager {
  WeatherData? _weatherData;

  Future<void> fetchWeather() async {
    String apiKey = const String.fromEnvironment("API_KEY");
    Map<String, double> locationData = await getLocation();
    double? latitude = locationData['latitude'];
    double? longitude = locationData['longitude'];

    String locationQuery = '$latitude,$longitude';
    final url =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$locationQuery&aqi=no';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var body = response.body;

        var decodedData = jsonDecode(body);

        if (decodedData != null) {
          _weatherData = WeatherData.fromJson(decodedData);
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<WeatherData> getWeather() async {
    if (_weatherData == null) {
      await fetchWeather();
    }
    return _weatherData!;
  }
}
