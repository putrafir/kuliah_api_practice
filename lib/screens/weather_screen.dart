import 'package:flutter/material.dart';
import '../api/api_service.dart';

class WeatherSearchScreen extends StatefulWidget {
  @override
  _WeatherSearchScreenState createState() => _WeatherSearchScreenState();
}

class _WeatherSearchScreenState extends State<WeatherSearchScreen> {
  final ApiService apiService = ApiService();
  String query = '';
  Map<String, dynamic>? weatherData;
  double averageTemp = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Weather'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future:
                  apiService.fetchWeather(query.isNotEmpty ? query : 'Jakarta'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (snapshot.hasData) {
                    weatherData = snapshot.data!;
                    // Menghitung suhu rata-rata
                    averageTemp =
                        apiService.calculateAverageTemperature(weatherData!);
                  }

                  return Center(
                    child: weatherData != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Average Temperature: $averageTemp°C'),
                              Text('City: ${weatherData!['name']}'),
                              Text(
                                  'Temperature: ${weatherData!['main']['temp']}°C'),
                              Text(
                                  'Weather: ${weatherData!['weather'][0]['description']}'),
                            ],
                          )
                        : CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
