import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_state.dart';
import './weather_service.dart';
import '../models/weather_model.dart';

class GeolocationException implements Exception {
  final String message;
  final GeolocationErrorType type;

  GeolocationException(this.message, this.type);

  @override
  String toString() => 'GeolocationException: $message ($type)';
}

enum GeolocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  unknown,
  initialPermissionDenied, // First start of App
}

class GeolocationService {
  Future<void> showErrorDialog(
    BuildContext context,
    String title,
    String content,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.red[50],
          icon: Icon(Icons.error_outline, color: Colors.red[700], size: 48),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.red[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }

  Future<Position> _checkAndRequestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw GeolocationException(
        'Location services are disabled. Please enable them in your device settings.',
        GeolocationErrorType.serviceDisabled,
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw GeolocationException(
          'Location permissions are denied. Please grant permission to use location services.',
          GeolocationErrorType.permissionDenied,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw GeolocationException(
        'Location permissions are permanently denied. Please enable them in your device settings.',
        GeolocationErrorType.permissionDeniedForever,
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );
  }

  Future<void> handleInitialLocationRequest(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasRunBefore = prefs.getBool('hasRunBefore') ?? false;

    if (!hasRunBefore) {
      try {
        await _checkAndRequestLocationPermission();
        await prefs.setBool('hasAcceptedLocationInitially', true);
        debugPrint('Location accepted on first launch.');
        if (context.mounted) {
          fetchLocation(context);
        }
      } on GeolocationException catch (e) {
        debugPrint('Location denied or issue on first launch: ${e.message}');
        await prefs.setBool('hasAcceptedLocationInitially', false);

        if (context.mounted) {
          showErrorDialog(
            context,
            'Location Required',
            'For a full experience, please enable location services. You can do this later via the location button.',
          );
        }
      } catch (e) {
        debugPrint('Unexpected error on initial location request: $e');
        await prefs.setBool('hasAcceptedLocationInitially', false);
        if (context.mounted) {
          showErrorDialog(
            context,
            'Location Error',
            'An unexpected error occurred during the location request: $e',
          );
        }
      } finally {
        await prefs.setBool('hasRunBefore', true);
      }
    }
  }

  Future<Position> _getActualCurrentLocation() async {
    return await _checkAndRequestLocationPermission();
  }

  Future<void> fetchLocation(BuildContext context) async {
    final WeatherService weatherService = WeatherService();
    try {
      Position position = await _getActualCurrentLocation();

      if (!context.mounted) return;

      context.read<AppState>().searchController.clear();
      context.read<AppState>().citySuggestions.clear();
      context.read<AppState>().setSearchText('');
      context.read<AppState>().setLocationMessage(
        'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
      );

      context.read<AppState>().setLatAndLong(
        position.latitude.toString(),
        position.longitude.toString(),
      );

      WeatherData weatherData = await weatherService.fetchWeatherData(
        position.latitude.toString(),
        position.longitude.toString(),
      );

      if (!context.mounted) return;
      context.read<WeatherDataProvider>().setWeatherData(weatherData);

      if (!context.mounted) return;
      context.read<AppState>().setShowPageInformation(true);
      context.read<AppState>().setlocationButtonColor(true);
    } on GeolocationException catch (e) {
      debugPrint('Geolocation Error (from button): ${e.message}');
      if (context.mounted) {
        showErrorDialog(context, 'Location Error', e.message);
      }
      if (context.mounted) {
        context.read<AppState>().setLocationMessage('Error: ${e.message}');
      }
    } catch (e) {
      debugPrint('An unexpected error occurred (from button): $e');
      if (context.mounted) {
        showErrorDialog(
          context,
          'Unexpected Error',
          'An unexpected error occurred: $e',
        );
      }
      if (context.mounted) {
        context.read<AppState>().setLocationMessage('Unexpected error: $e');
      }
    }
  }

  Future<void> searchCities(BuildContext context) async {
    if (context.read<AppState>().searchController.text.isNotEmpty) {
      final WeatherService weatherService = WeatherService();
      List<dynamic> result = await weatherService.getCitySuggestions(
        context.read<AppState>().searchController.text,
      );
      if (context.mounted) {
        context.read<AppState>().setCitySuggestions(result);
      }
    }
  }
}
