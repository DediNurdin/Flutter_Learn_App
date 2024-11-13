import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_learn/weather_app/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  fetchWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=509079b22fae7e954dff8403ef5eba0e"),
    );
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
