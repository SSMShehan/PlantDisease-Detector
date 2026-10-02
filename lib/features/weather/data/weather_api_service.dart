import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart'; // Uncomment when .env is set up

class WeatherApiService {
  // To use real data, set up dotenv and pass the API key. 
  // For now, we fallback to mock if no key is provided so the app won't crash.
  Future<WeatherModel> fetchCurrentWeather(double lat, double lon) async {
    try {
      // Free Open-Meteo API - no API key required
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&hourly=relative_humidity_2m');
          
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load weather: $e');
    }
  }
}
