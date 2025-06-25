import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import './weather_service.dart';

import '../models/weather_model.dart';

class GeolocationService {
  Future<void> showErrorDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          true, // L'utilisateur peut fermer en cliquant à l'extérieur
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // Une couleur de fond rouge très claire pour ne pas être agressive
          backgroundColor: Colors.red[50],
          // Une icône pour renforcer visuellement le message d'erreur
          icon: Icon(Icons.error_outline, color: Colors.red[700], size: 48),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.red[900], // Titre en rouge foncé
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
            ), // Contenu en noir pour la lisibilité
          ),
          actionsAlignment: MainAxisAlignment.center, // Centre le bouton
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red[800], // Texte du bouton en rouge
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // "pop" ferme la boîte de dialogue
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
          // Des bords arrondis pour un look moderne
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }

  Future<void> getCurrentLocationDialogError(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          return showErrorDialog(
            context,
            'Location',
            'Location services are disabled.',
          );
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            return showErrorDialog(
              context,
              'Location',
              'Location permissions are denied.',
            );
          }
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          return showErrorDialog(
            context,
            'Location',
            'Location permissions are permanently denied.',
          );
        }
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
      return;
    } catch (e) {
      if (context.mounted) {
        return showErrorDialog(context, 'Location', 'An error occurred: $e');
      }
    }
  }

  Future<String> getCurrentLocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          getCurrentLocationDialogError(context);
        }
        return 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            getCurrentLocationDialogError(context);
          }
          return 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          getCurrentLocationDialogError(context);
        }
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

      String result = await getCurrentLocation(context);

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

        WeatherData weatherData = await weatherService.fetchWeatherData(
          latitude.toString(),
          longitude.toString(),
        );

        if (context.mounted) {
          context.read<WeatherDataProvider>().setWeatherData(weatherData);
        }
        if (context.mounted) {
          context.read<AppState>().setShowPageInformation(true);
          context.read<AppState>().setlocationButtonColor(true);
        }
      }
    } catch (e) {
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
