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
  initialPermissionDenied, // Pour le cas spécifique du premier lancement
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
        'Les services de localisation sont désactivés.',
        GeolocationErrorType.serviceDisabled,
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw GeolocationException(
          'Les permissions de localisation sont refusées.',
          GeolocationErrorType.permissionDenied,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw GeolocationException(
        'Les permissions de localisation sont refusées de manière permanente. Veuillez les activer dans les paramètres de votre appareil.',
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
        debugPrint('Localisation acceptée au premier lancement.');
        if (context.mounted) {
          fetchLocation(context);
        }
      } on GeolocationException catch (e) {
        debugPrint(
          'Localisation refusée ou problème au premier lancement: ${e.message}',
        );
        await prefs.setBool('hasAcceptedLocationInitially', false);

        if (context.mounted) {
          showErrorDialog(
            context,
            'Localisation Requise',
            'Pour une expérience complète, veuillez activer les services de localisation. Vous pouvez le faire plus tard via le bouton de localisation.',
          );
        }
      } catch (e) {
        debugPrint(
          'Erreur inattendue au premier lancement de la localisation: $e',
        );
        await prefs.setBool('hasAcceptedLocationInitially', false);
        if (context.mounted) {
          showErrorDialog(
            context,
            'Erreur de Localisation',
            'Une erreur inattendue est survenue lors de la demande de localisation: $e',
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
        showErrorDialog(context, 'Erreur de Localisation', e.message);
      }
      if (context.mounted) {
        context.read<AppState>().setLocationMessage('Erreur: ${e.message}');
      }
    } catch (e) {
      debugPrint('An unexpected error occurred (from button): $e');
      if (context.mounted) {
        showErrorDialog(
          context,
          'Erreur Inattendue',
          'Une erreur inattendue est survenue: $e',
        );
      }
      if (context.mounted) {
        context.read<AppState>().setLocationMessage('Erreur inattendue: $e');
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
