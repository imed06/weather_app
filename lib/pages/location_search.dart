import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LocationSearch extends StatefulWidget {
  const LocationSearch({super.key});

  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  Future<List<dynamic>> _searchPlaces(String query) async {
    final String apiKey = dotenv.env['MAPBOX_API_KEY'] ?? '';
    final String apiUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json';

    try {
      final response = await http.get(Uri.parse('$apiUrl?access_token=$apiKey'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['features'];
      } else {
        throw Exception('Failed to load search results.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  void initState() {
    _searchPlaces("berlin");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('location',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 50),
        child: Column(
          children: [
            const Text("Find the area or city that you want to know the detailed weather info",textAlign: TextAlign.center,),
            const SizedBox(height: 25,),
            TextField(
              controller: _searchController,
              onChanged: (value) async {
                final results = await _searchPlaces(value);
                setState(() {
                  _searchResults = results;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: 'Search',
                hintStyle: const TextStyle(
                  color: Color(0xff4B4E9D)
                ),
                hoverColor: const Color(0xff4B4E9D),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: const BorderSide(),
                  borderRadius: BorderRadius.circular(12)
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchResults = [];
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final place = _searchResults[index];
                  return ListTile(
                    title: Text(place['place_name']),
                    onTap: () {
                      // Handle the selection of a location here.
                      // You can pass the selected location back to the HomeScreen.
                      Navigator.pop(context, place['place_name']);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
