import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherByCoordinatesScreen extends StatefulWidget {
  @override
  _WeatherByCoordinatesScreenState createState() => _WeatherByCoordinatesScreenState();
}

class _WeatherByCoordinatesScreenState extends State<WeatherByCoordinatesScreen> {
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();

  String result = '';

  Future<void> fetchWeather(String lat, String lon) async {
    const String apiKey = 'TU_API_KEY';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric52f9815bf7018ba5702fd1e569959910 ';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          result =
              'Temperatura: ${data['main']['temp']}°C\nHumedad: ${data['main']['humidity']}%\nDescripción: ${data['weather'][0]['description']}';
        });
      } else {
        setState(() {
          result = 'Error al obtener datos del clima.';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima por Coordenadas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: latController,
              decoration: InputDecoration(labelText: 'Latitud'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: lonController,
              decoration: InputDecoration(labelText: 'Longitud'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final lat = latController.text;
                final lon = lonController.text;
                if (lat.isNotEmpty && lon.isNotEmpty) {
                  fetchWeather(lat, lon);
                }
              },
              child: Text('Consultar'),
            ),
            SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
