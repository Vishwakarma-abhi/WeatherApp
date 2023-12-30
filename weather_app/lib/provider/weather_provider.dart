import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/const.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:provider/provider.dart';
import 'package:weather_app/provider/location_provider.dart';

class WeatherProvider with ChangeNotifier {
  Map<String, dynamic> _weatherData = {};

  Map<String, dynamic> get weatherData => _weatherData;

  Future<void> fetchWeatherData(String cityName) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apikey'));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = response.body;
        final weatherInfo = parseWeatherInfo(jsonData);
        _weatherData[cityName] = weatherInfo;
        notifyListeners();
      } else {
        print("Failed to load weather data: ${response.statusCode}");
        // Handle specific error cases here
      }
    } catch (e) {
      print("Error: $e");
      // Handle general error cases here
    }
  }

  Map<String, dynamic> parseWeatherInfo(String jsonData) {
    final Map<String, dynamic> data = json.decode(jsonData);

    final String cityName = data['name'];
    final double temperature = convertKelvinToCelsius(data['main']['temp']);
    final String weatherDescription = data['weather'][0]['description'];
    final String weatherIcon = data['weather'][0]['icon'];
    final double windSpeed = data['wind']['speed'];
    final double humidity = data['main']['humidity'].toDouble();
    final int sunriseTimestamp = data['sys']['sunrise'];
    final int sunsetTimestamp = data['sys']['sunset'];

    print(sunriseTimestamp);

    return {
      'cityName': cityName,
      'temperature': temperature,
      'weatherDescription': weatherDescription,
      'icon': weatherIcon,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'sunrise': sunriseTimestamp,
      'sunset': sunsetTimestamp,
    };
  }

  // Function to convert temperature from Kelvin to Celsius
  double convertKelvinToCelsius(double temperatureKelvin) {
    return temperatureKelvin - 273.15;
  }
}
