import 'package:flutter/material.dart';
import 'weather_model.dart';
import '../services/weather_service.dart';
import 'package:provider/provider.dart';

class AppState with ChangeNotifier {
  List<dynamic> _citySuggestions = [];

  String _searchText = '';
  String _locationMessage = '';
  int _selectedIndex = 0;
  double _currentDegrees = 0.0;
  bool _showPageInformation = false;
  bool _locationButtonColor = false;
  bool _errorLocation = false;

  List<dynamic> get citySuggestions => _citySuggestions;

  String get searchText => _searchText;
  String get locationMessage => _locationMessage;
  int get selectedIndex => _selectedIndex;
  double get currentDegrees => _currentDegrees;
  bool get showPageInformation => _showPageInformation;
  bool get locationButtonColor => _locationButtonColor;
  bool get errorLocation => _errorLocation;

  String _latitude = '';
  String _longitude = '';
  String _city = '';
  String _country = '';
  String _code = '';
  String _region = '';

  String get latitude => _latitude;
  String get longitude => _longitude;
  String get city => _city;
  String get country => _country;
  String get code => _code;
  String get region => _region;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  void setShowPageInformation(bool result) {
    _showPageInformation = result;
    notifyListeners();
  }

  void setErrorLocation(bool result) {
    _errorLocation = result;
    notifyListeners();
  }

  void setlocationButtonColor(bool result) {
    _locationButtonColor = result;
    notifyListeners();
  }

  void setCurrentDegrees(double degrees) {
    _currentDegrees = degrees;
    notifyListeners();
  }

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void setLocationMessage(String message) {
    _locationMessage = message;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setCitySuggestions(List<dynamic> data) {
    _citySuggestions = data;
    notifyListeners();
  }

  void setLatAndLong(String lat, String long) {
    _latitude = lat;
    _longitude = long;
    notifyListeners();
  }

  void setCityCountryCodeRegion(
    String city,
    String country,
    String code,
    String region,
  ) {
    _city = city;
    _country = country;
    _code = code;
    _region = region;
    notifyListeners();
  }

  void onTapSearch(BuildContext context) {
    if (_searchController.text.isNotEmpty) {
      setLocationMessage('');
      var result =
          citySuggestions.where((suggestion) {
            return suggestion['name'].toLowerCase() ==
                _searchController.text.toLowerCase();
          }).toList();
      if (result.isEmpty) {
        setSearchText("City not found");
      } else {
        setLatAndLong(
          result[0]['latitude']?.toString() ?? 'Unkown',
          result[0]['longitude']?.toString() ?? 'Unkown',
        );
        setCityCountryCodeRegion(
          result[0]['city']?.toString() ?? 'Unkown',
          result[0]['country']?.toString() ?? 'Unkown',
          result[0]['code']?.toString() ?? 'Unkown',
          result[0]['region']?.toString() ?? 'Unkown',
        );
        setSearchText(
          "'${result[0]['name']} : Latitude: ${result[0]['latitude']}, Longitude: ${result[0]['longitude']}'",
        );
        _allLocation(context);
      }
      _searchController.clear();
      setShowPageInformation(true);
      setlocationButtonColor(false);
    }
    notifyListeners();
  }

  Future<void> onTapListSearch(BuildContext context, dynamic suggestion) async {
    if (_searchController.text.isNotEmpty) {
      setLocationMessage('');
      debugPrint(
        'Suggestion: $suggestion hhshsthststhsshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsthshsthststhsththsththth',
      );
      setLatAndLong(
        suggestion['latitude']?.toString() ?? 'Unkown',
        suggestion['longitude']?.toString() ?? 'Unkown',
      );
      setCityCountryCodeRegion(
        suggestion['city']?.toString() ?? 'Unkown',
        suggestion['country']?.toString() ?? 'Unkown',
        suggestion['code']?.toString() ?? 'Unkown',
        suggestion['region']?.toString() ?? 'Unkown',
      );
      setSearchText(
        "'${suggestion['name']} : Latitude: ${suggestion['latitude']}, Longitude: ${suggestion['longitude']}'",
      );
      await _allLocation(context);
      if (context.mounted) {
        setShowPageInformation(true);
        setlocationButtonColor(false);
      }
    }
    _searchController.clear();
    notifyListeners();
  }

  Future<void> _allLocation(BuildContext context) async {
    final WeatherService weatherService = WeatherService();
    debugPrint('[_allLocation] Latitude: $latitude, Longitude: $longitude');
    WeatherData? weatherData;
    try {
      weatherData = await weatherService.fetchWeatherData(
        latitude.toString(),
        longitude.toString(),
      );
      debugPrint('[_allLocation] Données récupérées: $weatherData');
    } catch (e) {
      debugPrint(
        '[_allLocation] Erreur lors de la récupération des données: $e',
      );
      return;
    }

    // Mettre à jour le provider UNIQUEMENT si le contexte est toujours monté
    if (context.mounted) {
      debugPrint('[_allLocation] Contexte monté, appel de setWeatherData');
      context.read<WeatherDataProvider>().setWeatherData(weatherData);
      setCurrentDegrees(weatherData.current.temperature);
      debugPrint('[_allLocation] setWeatherData terminé');
    } else {
      debugPrint('[_allLocation] Contexte n\'est plus monté');
    }
  }
}
