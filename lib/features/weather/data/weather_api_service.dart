import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart'; // Uncomment when .env is set up

class WeatherApiService {
  // To use real data, set up dotenv and pass the API key. 
  // For now, we fallback to mock if no key is provided so the app won't crash.
  Future<WeatherModel> fetchCurrentWeather(double lat, double lon) async {
    try {
      // String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
      String apiKey = ''; // Leave empty to trigger fallback, or put real key here
      
      if (apiKey.isEmpty) {
        // Fallback to mock data to prevent crashes while testing
        await Future.delayed(const Duration(seconds: 1)); // simulate network delay
        return WeatherModel.mock();
      }

      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey');
          
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      // Fallback
      return WeatherModel.mock();
    }
  }
}
