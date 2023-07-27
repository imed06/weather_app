import 'package:e_commerce/pages/home.dart';
import 'package:e_commerce/pages/location_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      theme: ThemeData(
        fontFamily: 'QuickSand', // Specify the default font family for the entire app.
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        "/locationSearch": (context) =>LocationSearch(),
      },
    );
  }
}
