import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  Future<WeatherModel?> fetchWeather(String city) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    // Here you would normally fetch data from an API
    // For demonstration, we will create a dummy WeatherModel
    final String baseURL = "https://api.openweathermap.org/data/2.5/";
    final String apiKey = "YOUR_API_KEY";
    try {
      String url = "$baseURL/weather?q=$city&appid=$apiKey&units=metric"; // Your API URL here
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> jasonData = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(jasonData);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
      

  }
}