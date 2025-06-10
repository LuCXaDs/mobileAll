import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/weather_model.dart';

class WeatherService {
  Future<List<dynamic>> getCitySuggestions(String query) async {
    debugPrint('Query: $query');

    final url = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query,
    });

    try {
      final response = await http.get(url);

      // debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // debugPrint('${data}');

        if (data.containsKey('results') && data['results'] is List) {
          return data['results'].map((item) {
            return {
              'name': item['name'],
              'country': item['country'],
              'code': item['country_code'],
              'region': item['admin1'] ?? 'Unknown',
              'latitude': item['latitude'],
              'longitude': item['longitude'],
            };
          }).toList();
        } else {
          throw Exception(
            'Failed to load city suggestions: Invalid response format',
          );
        }
      } else {
        throw Exception(
          'Failed to load city suggestions: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getCityInformation(
    String latitude,
    String longitude,
  ) async {
    // debugPrint('Latitude: $latitude, Longitude: $longitude');

    final url = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'format': 'jsonv2',
      'lat': latitude.toString(),
      'lon': longitude.toString(),
    });

    try {
      final response = await http.get(url);

      // debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // debugPrint('Data: $data');

        if (data.containsKey('address') &&
            data['address'] is Map<String, dynamic>) {
          final address = data['address'] as Map<String, dynamic>;
          return {
            'name':
                address['city'] ??
                address['town'] ??
                address['village'] ??
                'Unknown',
            'country': address['country'] ?? 'Unknown',
            'code': address['country_code'] ?? 'Unknown',
            'region': address['state'] ?? address['region'] ?? 'Unknown',
            'latitude': latitude,
            'longitude': longitude,
          };
        } else {
          throw Exception(
            'Failed to load city information: Invalid response format',
          );
        }
      } else {
        throw Exception(
          'Failed to load city information: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load city information');
    }
  }

  Future<Map<String, dynamic>> fetchWeather(
    String latitude,
    String longitude,
  ) async {
    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['current_weather'];
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherData> fetchWeatherData(
    String latitude,
    String longitude,
  ) async {
    final String apiUrl = 'https://api.open-meteo.com/v1/forecast';
    final url =
        '$apiUrl?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,weather_code,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min,weather_code&current=temperature_2m,weather_code,wind_speed_10m,pressure_msl,uv_index,relative_humidity_2m,apparent_temperature&timezone,precipitation=auto';
    debugPrint(url);

    final response = await http.get(Uri.parse(url));
    // debugPrint(response.body);

    if (response.statusCode == 200) {
      final cityInfo = await getCityInformation(latitude, longitude);
      debugPrint('$cityInfo');

      final data = json.decode(response.body);

      final hourlyWeather =
          (data['hourly']['time'] as List?)?.asMap().entries.map((entry) {
            final index = entry.key;
            final time = entry.value;
            return HourlyWeather(
              time: time,
              temperature: data['hourly']['temperature_2m'][index] ?? 0.0,
              weatherCode: data['hourly']['weather_code'][index] ?? 0,
              windSpeed: data['hourly']['wind_speed_10m'][index] ?? 0.0,
            );
          }).toList() ??
          [];

      final dailyWeather =
          (data['daily']['time'] as List?)?.asMap().entries.map((entry) {
            final index = entry.key;
            final time = entry.value;
            return DailyWeather(
              time: time,
              maxTemperature: data['daily']['temperature_2m_max'][index] ?? 0.0,
              minTemperature: data['daily']['temperature_2m_min'][index] ?? 0.0,
              weatherCode: data['daily']['weather_code'][index] ?? 0,
            );
          }).toList() ??
          [];

      final currentWeather = CurrentWeather(
        temperature: data['current']['temperature_2m'] ?? 0.0,
        weatherCode: data['current']['weather_code'] ?? 0,
        windSpeed: data['current']['wind_speed_10m'] ?? 0.0,
        pressure: data['current']['pressure_msl'] ?? 0.0,
        uvIndex: data['current']['uv_index'] ?? 0.0,
        humidity: data['current']['relative_humidity_2m'] ?? 0,
        apparentTemperature: data['current']['apparent_temperature'] ?? 0.0,
        precipitation: data['current']['precipitation'] ?? 0.00,
      );

      return WeatherData(
        latitude: data['latitude'] ?? 0.0,
        longitude: data['longitude'] ?? 0.0,
        timezone: data['timezone'] ?? '',
        city: cityInfo['name'],
        country: cityInfo['country'],
        code: cityInfo['code'],
        region: cityInfo['region'],
        hourly: hourlyWeather,
        daily: dailyWeather,
        current: currentWeather,
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
