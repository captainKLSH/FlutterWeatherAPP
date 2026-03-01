import 'package:weather/models/weather_condition.dart';
import 'package:weather/models/main_weather_data.dart';

class WeatherModel {
  final String cityName;
  final String country;
  final WeatherCondition condition;
  final MainWeatherData main;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.condition,
    required this.main,
  });

  WeatherModel.fromJson(Map<String, dynamic> json)
      : cityName = json['name'],
        country = json['sys']['country'],
        condition = WeatherCondition.fromJson(json),
        main = MainWeatherData.fromJson(json);
}