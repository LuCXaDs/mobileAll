import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';

import '../widgets/current_degrees.dart';
import '../widgets/current_weather.dart';
import '../widgets/today_carroussel_weather.dart';
import '../widgets/Weekly_carroussel_weather.dart';
import '../widgets/country_city_region_flag.dart';

class CurrentlyPage extends StatefulWidget {
  const CurrentlyPage({super.key});

  @override
  State<CurrentlyPage> createState() => CurrentlyPageState();
}

class CurrentlyPageState extends State<CurrentlyPage> {
  WeatherData? _weatherData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherData = context.watch<WeatherDataProvider>().weatherData;
    debugPrint(
      '[CurrentlyPage] didChangeDependencies, weatherData: $_weatherData',
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[CurrentlyPage] Build appelé, weatherData: $_weatherData');
    if (_weatherData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CountryCityRegionFlag(weatherData: _weatherData!),
          const SizedBox(height: 10),
          WeatherInfoRow(weatherData: _weatherData!),
          const SizedBox(height: 20),
          WeatherCurrentAllInfo(weatherData: _weatherData!),
          const SizedBox(height: 30),
          TodayCarrousselWeather(weatherData: _weatherData!),
          const SizedBox(height: 30),
          WeeklyCarrousselWeather(weatherData: _weatherData!),
        ],
      ),
    );
  }
}
