import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoordinatesPage extends StatefulWidget {
  const CoordinatesPage({super.key});

  @override
  _CoordinatesPageState createState() => _CoordinatesPageState();
}

class _CoordinatesPageState extends State<CoordinatesPage> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();
  String _weatherInfo = '';

  Future<void> _fetchWeather(double lat, double lon) async {
    final apiKey = dotenv.env['API_KEY'];
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherInfo = 'Temperatura: ${data['main']['temp']}°F\n'
            'Temperatura celsius: ${data['main']['temp'] - 273.15}°C\n'
            'Clima: ${data['weather'][0]['description']}';
      });
    } else {
      setState(() {
        _weatherInfo = 'Error al obtener datos del clima';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima por coordenadas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _latController,
              decoration: const InputDecoration(
                labelText: 'Ingrese latitud',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _lonController,
              decoration: const InputDecoration(
                  labelText: 'Ingrese longitud',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final lat = double.parse(_latController.text);
                final lon = double.parse(_lonController.text);
                _fetchWeather(lat, lon);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Consultar clima'),
            ),
            const SizedBox(height: 20),
            Text(_weatherInfo,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
