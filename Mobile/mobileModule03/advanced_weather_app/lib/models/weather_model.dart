import 'package:flutter/material.dart';

class WeatherDataProvider with ChangeNotifier {
  WeatherData? _weatherData;

  WeatherData? get weatherData => _weatherData;

  void setWeatherData(WeatherData data) {
    _weatherData = data;
    debugPrint(
      '[WeatherDataProvider] setWeatherData appelé avec: $_weatherData',
    );
    notifyListeners();
    debugPrint('[WeatherDataProvider] notifyListeners() appelé');
  }
}

class WeatherData {
  final DateTime time;
  final DateTime today;
  final double latitude;
  final double longitude;
  final String timezone;
  final String city;
  final String country;
  final String code;
  final String region;

  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;
  final CurrentWeather current;

  WeatherData({
    DateTime? time,
    DateTime? today,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.timezone = '',
    this.city = '',
    this.country = '',
    this.code = '',
    this.region = '',
    this.hourly = const [],
    this.daily = const [],
    CurrentWeather? current,
  }) : current = current ?? CurrentWeather.withDefaults(),
       time = time ?? DateTime.now(),
       today = DateTime(
         (time ?? DateTime.now()).year,
         (time ?? DateTime.now()).month,
         (time ?? DateTime.now()).day,
       );

  String getWeatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Cloudy';
      case 45:
      case 48:
        return 'Fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 56:
      case 57:
        return 'Freezing Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 66:
      case 67:
        return 'Freezing Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow';
      case 77:
        return 'Snow grains';
      case 80:
      case 81:
      case 82:
        return 'Rain showers';
      case 85:
      case 86:
        return 'Snow showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with hail';
      default:
        return 'Unknown';
    }
  }

  String getImageForWeatherCode(String weatherCode) {
    int code = int.parse(weatherCode);
    switch (code) {
      case 0:
        return 'assets/weather/clear_sky.png';
      case 1:
      case 2:
      case 3:
        return 'assets/weather/cloudy.png';
      case 45:
      case 48:
        return 'assets/weather/fog.png';
      case 51:
      case 53:
      case 55:
        return 'assets/weather/drizzle.png';
      case 56:
      case 57:
        return 'assets/weather/drizzle.png';
      case 61:
      case 63:
      case 65:
        return 'assets/weather/rain.png';
      case 66:
      case 67:
        return 'assets/weather/rain.png';
      case 71:
      case 73:
      case 75:
        return 'assets/weather/snow.png';
      case 77:
        return 'assets/weather/snow.png';
      case 80:
      case 81:
      case 82:
        return 'assets/weather/rain_showers.png';
      case 85:
      case 86:
        return 'assets/weather/snow.png';
      case 95:
        return 'assets/weather/thunderstrom.png';
      case 96:
      case 99:
        return 'assets/weather/thunderstrom.png';
      default:
        return 'assets/weather/clear_sky.png';
    }
  }
}

class HourlyWeather {
  final String time;
  final double temperature;
  final int weatherCode;
  final double windSpeed;

  HourlyWeather({
    this.time = '',
    this.temperature = 0.0,
    this.weatherCode = 0,
    this.windSpeed = 0.0,
  });
}

class DailyWeather {
  final String time;
  final double maxTemperature;
  final double minTemperature;
  final int weatherCode;

  DailyWeather({
    this.time = '',
    this.maxTemperature = 0.0,
    this.minTemperature = 0.0,
    this.weatherCode = 0,
  });
}

class CurrentWeather {
  final double temperature;
  final int weatherCode;
  final double windSpeed;
  final double pressure;
  final double uvIndex;
  final int humidity;
  final double apparentTemperature;
  final double precipitation;

  CurrentWeather({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    required this.pressure,
    required this.uvIndex,
    required this.humidity,
    required this.apparentTemperature,
    required this.precipitation,
  });

  factory CurrentWeather.withDefaults() {
    return CurrentWeather(
      temperature: 0.0,
      weatherCode: 0,
      windSpeed: 0.0,
      pressure: 0.0,
      uvIndex: 0.0,
      humidity: 0,
      apparentTemperature: 0.0,
      precipitation: 0.00,
    );
  }
}
