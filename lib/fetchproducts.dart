import 'dart:convert';
import 'package:flutter/services.dart';

Future<String> loadJsonFile(String path) async {
  return await rootBundle.loadString(path);
}

Future<Map<String, dynamic>> fetchConditions() async {
  String jsonString = await loadJsonFile('assets/conditions.json');
  Map<String, dynamic> data = json.decode(jsonString);
  return data;
}

Future<Map<String, dynamic>> fetchProducts() async {
  String jsonString = await loadJsonFile('assets/items.json');
  Map<String, dynamic> data = json.decode(jsonString);
  return data;
}
