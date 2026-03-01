
import 'package:flutter_riverpod/legacy.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/services/weather_state.dart';

class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier() : super(WeatherState());
  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeather(String cityName) async {
  if(cityName.isEmpty) {
    state = state.copyWith(errorMessage: 'City name cannot be empty', weather: null);
    return;
  }
  state = state.copyWith(isLoading: true, errorMessage: '', weather: null);
  try {
    // Simulate network call
    // Here you would normally call your WeatherService to fetch data
    // For demonstration, we will create a dummy WeatherModel
    final weather = await _weatherService.fetchWeather(cityName);
    state = state.copyWith(isLoading: false, weather: weather);
  } catch (e) {
    state = state.copyWith(isLoading: false, weather: null, errorMessage: e.toString());
  }
}}

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>(
  (ref) => WeatherNotifier(),
);  
