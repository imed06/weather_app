import 'hourlyWeather.dart';

class Weather {
  final String location;
  final double temperature;
  final String weatherCondition;
  final String weatherIcon;
  final int humidity;
  final double wind;
  final List<HourlyWeather> hourlyWeather; // New property for hourly temperature data.

  Weather({
    required this.location,
    required this.temperature,
    required this.weatherCondition,
    required this.weatherIcon,
    required this.humidity,
    required this.wind,
    required this.hourlyWeather, // Initialize the hourlyWeather property.
  });
}
