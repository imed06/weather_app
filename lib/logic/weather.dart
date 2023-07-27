import 'dart:convert';
import 'package:e_commerce/models/hourlyWeather.dart';
import 'package:e_commerce/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Weather> fetchWeather(String location) async {
  final String apiKey = dotenv.env['OPEN_WEATHER_MAP_API_KEY'] ?? '';
  final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$apiKey';
  final String hourlyWeatherApiUrl = 'https://api.openweathermap.org/data/2.5/forecast?q=$location&units=metric&appid=$apiKey';
  print(apiUrl);

  try {
    final response = await http.get(Uri.parse(apiUrl));
    final hourlyWeatherResponse = await http.get(Uri.parse(hourlyWeatherApiUrl));


    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final hourlyWeatherData = json.decode(hourlyWeatherResponse.body);

      final String locationName = jsonData['name'];
      final double temperature = jsonData['main']['temp'];
      final String weatherCondition = jsonData['weather'][0]['main'];
      final String weatherIconCode = jsonData['weather'][0]['icon'];
      final int humidity = jsonData['main']['humidity'];
      final double wind = jsonData['wind']['speed'];
      final weatherIcon = 'https://openweathermap.org/img/w/$weatherIconCode.png';

      print(hourlyWeatherData);

      final List<dynamic> hourlyDataList = hourlyWeatherData['list'];
      final List<HourlyWeather> hourlyWeatherList = [];


      for (var hourlyData in hourlyDataList) {
        final int timestamp = hourlyData['dt'] * 1000; // Convert timestamp to milliseconds.
        final DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp);

        final double temp = hourlyData['main']['temp'].toDouble();

        final hourlyWeather = HourlyWeather(time: time, temperature: temp);
        hourlyWeatherList.add(hourlyWeather);
      }

      return Weather(
        location: locationName,
        temperature: temperature,
        weatherCondition: weatherCondition,
        weatherIcon: weatherIcon,
        hourlyWeather: hourlyWeatherList,
        humidity: humidity,
        wind: wind
      );
    } else {
      throw Exception('Failed to load weather data.');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
