import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';

import '../widgets/current_degrees.dart';
import '../widgets/Weekly_carroussel_weather.dart';
import '../widgets/country_city_region_flag.dart';
import '../widgets/weekly_temperature_data.dart';

class WeeklyPage extends StatefulWidget {
  const WeeklyPage({super.key});

  @override
  State<WeeklyPage> createState() => WeeklyPageState();
}

class WeeklyPageState extends State<WeeklyPage> {
  WeatherData? _weatherData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherData = context.watch<WeatherDataProvider>().weatherData;
  }

  @override
  Widget build(BuildContext context) {
    if (_weatherData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        children: [
          CountryCityRegionFlag(weatherData: _weatherData!),
          SizedBox(height: 10),
          WeatherInfoRow(weatherData: _weatherData!),
          SizedBox(height: 20),
          WeeklyCarrousselWeather(weatherData: _weatherData!),
          SizedBox(height: 20),
          DailyTemperatureChart(weatherData: _weatherData!),
        ],
      ),
    );
  }
}
