import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';

import '../widgets/current_degrees.dart';
import '../widgets/today_carroussel_weather.dart';
import '../widgets/country_city_region_flag.dart';
import '../widgets/today_temperature_data.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => TodayPageState();
}

class TodayPageState extends State<TodayPage> {
  WeatherData? _weatherData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherData = context.watch<WeatherDataProvider>().weatherData;
  }

  @override
  Widget build(BuildContext context) {
    if (_weatherData == null) {
      // return const Center(child: CircularProgressIndicator());
      // return;
      return Center(
        child: Text(
          'Today',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        children: [
          CountryCityRegionFlag(weatherData: _weatherData!),
          SizedBox(height: 10),
          WeatherInfoRow(weatherData: _weatherData!),
          SizedBox(height: 20),
          TodayCarrousselWeather(weatherData: _weatherData!),
          SizedBox(height: 20),
          TemperatureChartPage(weatherData: _weatherData!),
        ],
      ),
    );
  }
}
