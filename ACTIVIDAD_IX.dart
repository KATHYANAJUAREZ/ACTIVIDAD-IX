import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherByCityScreen extends StatefulWidget {
  @override
  _WeatherByCityScreenState createState() => _WeatherByCityScreenState();
}

class _WeatherByCityScreenState extends State<WeatherByCityScreen> {
  final TextEditingController cityController = TextEditingController();

  String result = '';

  Future<void> fetchWeather(String city) async {
    const String apiKey = 'TU_API_KEY';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

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
        title: Text('Clima por Ciudad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'Nombre de la Ciudad'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final city = cityController.text;
                if (city.isNotEmpty) {
                  fetchWeather(city);
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
