import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mimar/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherApiService {
  static Future<Map<String, dynamic>> getWeatherByCoords(double lat, double lon) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('JWT token not found.');

    final url = Uri.parse('${Env.weatherUrl}?lat=$lat&lon=$lon');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to fetch weather');
    }
  }
}
