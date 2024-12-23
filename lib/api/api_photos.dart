import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<List<dynamic>> fetchPhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('photos');

    if (cachedData != null) {
      return json.decode(cachedData);
    } else {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

      if (response.statusCode == 200) {
        prefs.setString('photos', response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load photos');
      }
    }
  }
}
