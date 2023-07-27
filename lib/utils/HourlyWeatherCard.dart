import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class HourlyWeatherCard extends StatelessWidget {
  final String hour;
  final String weatherIcon;
  final String temperature;
  final int color;

  HourlyWeatherCard({required this.hour, required this.weatherIcon, required this.temperature, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(color), // Set the background color to #4B4E9D.
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjust vertical padding.
        child: Row(
          children: [
            Image.asset(
              weatherIcon,
              height: 40,
              width: 40,
            ),
            SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hour,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  temperature,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
