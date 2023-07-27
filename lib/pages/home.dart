import 'package:e_commerce/logic/weather.dart';
import 'package:e_commerce/models/weather.dart';
import 'package:e_commerce/utils/HourlyWeatherCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLocation = 'berlin';
  final DateTime _currentTime = DateTime.now();

  void _openLocationSearch(BuildContext context) async {
    final selectedLocation =
        await Navigator.pushNamed(context, '/locationSearch') as String;
    _weatherData = fetchWeather(selectedLocation);
    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = selectedLocation;
      });
    }
  }

  late Future<Weather> _weatherData;

  Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void initState() {
    super.initState();
    _weatherData = fetchWeather(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xff686BCC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () => _openLocationSearch(context),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
            future: _weatherData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final weather = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            weather.location,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        DateFormat('EEE,d/M/y').format(_currentTime),
                        // Format to display day and time.
                        style: TextStyle(fontSize: 12, color: Colors.grey[300]),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 150,
                        child: ClipRRect(
                          child: Image.asset("images/cloud_sun.png"),
                        ),
                      ),
                      //Image.asset("images/sun.png"),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Temp",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${weather.temperature}',
                                // Display temperature with the '°C' symbol.
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Wind",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${weather.wind}km/h',
                                // Display temperature with the '°C' symbol.
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Humidity",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${weather.humidity}%',
                                // Display temperature with the '°C' symbol.
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Today",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                            TextButton(
                                onPressed: () {
                                  _launchUrl('https://www.youtube.com');
                                },
                                child: const Text("View full report",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white))),
                          ],
                        ),
                      ),
                      // Hourly Temperature List

                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weather.hourlyWeather.length,
                          itemBuilder: (context, index) {
                            final hourlyData = weather.hourlyWeather[index];
                            return index == 0
                                ? HourlyWeatherCard(
                                    hour: '${hourlyData.time.hour}:00',
                                    weatherIcon: "images/sun.png",
                                    temperature:
                                        '${hourlyData.temperature.toStringAsFixed(1)}°',
                                    color: 0xff4B4E9D,
                                  )
                                : HourlyWeatherCard(
                                    hour: '${hourlyData.time.hour}:00',
                                    weatherIcon: "images/sun.png",
                                    temperature:
                                        '${hourlyData.temperature.toStringAsFixed(1)}°',
                                    color: 0xff6F78DF,
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}

