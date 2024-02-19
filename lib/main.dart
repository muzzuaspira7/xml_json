import 'package:flutter/material.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart';
import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    const String apiUrl =
        'https://timesofindia.indiatimes.com/rssfeedstopstories.cms';

    try {
      final Response response = await get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Successfully fetched the data
        final String xmlData = response.body;
        print('XML Data: $xmlData'); // Print XML data
        final Xml2Json xml2json = Xml2Json();
        xml2json.parse(xmlData); // Parse XML data
        xml2json.toGData(); // Convert XML to JSON
        final String jsonData = xml2json.toParker(); // Get the JSON data
        log('JSON Data: $jsonData'); // Print JSON data
      }
    } catch (e) {
      // Handle Exception
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: InkWell(
        onTap: () {
          fetchData();
        },
        child: Container(
          color: Colors.green,
          height: double.infinity,
          width: double.infinity,
          child: Text('Bolo'),
        ),
      ),
    );
  }
}
