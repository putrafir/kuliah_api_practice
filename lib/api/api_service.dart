import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String apiKey = '449bb3c368cf9b088b46890ffff7a6b4';
  final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('weather_$city');

    if (cachedData != null) {
      return json.decode(cachedData);
    } else {
      final response = await http.get(
        Uri.parse('$apiUrl?q=$city&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        prefs.setString('weather_$city', response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    }
  }

  double calculateAverageTemperature(Map<String, dynamic> weatherData) {
    double totalTemperature = 0;
    int count = 1;

    if (weatherData['main'] != null) {
      totalTemperature += weatherData['main']['temp'];
    }

    return count > 0 ? totalTemperature / count : 0;
  }
}
