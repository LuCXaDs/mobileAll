import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import './weather_service.dart';

import '../models/weather_model.dart';

class GeolocationService {
  Future<String> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return 'Location permissions are permanently denied.';
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );
      debugPrint(
        'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
      );
      return 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  Future<void> fetchLocation(BuildContext context) async {
    try {
      final WeatherService weatherService = WeatherService();
      String result = await getCurrentLocation();

      // Mettre à jour l'état de l'application
      if (context.mounted) {
        context.read<AppState>().searchController.clear();
        context.read<AppState>().citySuggestions.clear();
        context.read<AppState>().setSearchText('');
        context.read<AppState>().setLocationMessage(result);
      }

      double latitude = 0.0;
      double longitude = 0.0;
      List<String> parts = result.split(',');
      if (parts.length == 2) {
        String latitudePart = parts[0].trim();
        String longitudePart = parts[1].trim();

        if (latitudePart.startsWith('Latitude:') &&
            longitudePart.startsWith('Longitude:')) {
          latitude = double.parse(
            latitudePart.substring('Latitude:'.length).trim(),
          );
          longitude = double.parse(
            longitudePart.substring('Longitude:'.length).trim(),
          );

          // print('Latitude: $latitude');
          // print('Longitude: $longitude');
        }
      }

      if (latitude != 0 && longitude != 0) {
        if (context.mounted) {
          context.read<AppState>().setLatAndLong(
            latitude.toString(),
            longitude.toString(),
          );
        }
        // debugPrint('$latitude, $longitude NAATEFEf');

        // Récupérer les données météorologiques
        WeatherData weatherData = await weatherService.fetchWeatherData(
          latitude.toString(),
          longitude.toString(),
        );

        // Mettre à jour le provider avec les données météorologiques
        if (context.mounted) {
          context.read<WeatherDataProvider>().setWeatherData(weatherData);
        }
        if (context.mounted) {
          context.read<AppState>().setShowPageInformation(true);
          context.read<AppState>().setlocationButtonColor(true);
        }
      }
    } catch (e) {
      // Gérer les erreurs ici
      debugPrint('Error fetching location: $e');
    }
  }

  Future<void> searchCities(BuildContext context) async {
    if (context.read<AppState>().searchController.text.isNotEmpty) {
      final WeatherService weatherService = WeatherService();
      List<dynamic> result = await weatherService.getCitySuggestions(
        context.read<AppState>().searchController.text,
      );
      // debugPrint('$result');
      if (context.mounted) {
        context.read<AppState>().setCitySuggestions(result);
      }
    }
  }
}
