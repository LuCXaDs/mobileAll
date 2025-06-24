import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import nécessaire pour les locales

class WeeklyCarrousselWeather extends StatelessWidget {
  final WeatherData weatherData;

  const WeeklyCarrousselWeather({super.key, required this.weatherData});

  List<Map<String, String>> _createDailyWeatherMaps() {
    // Initialise la localisation en français pour les noms des jours
    initializeDateFormatting('fr_FR', null);

    final List<Map<String, String>> dailyWeatherMaps = [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int count = 0;
    for (var daily in weatherData.daily) {
      if (count >= 7) {
        break;
      }

      final DateTime dateFromData = DateTime.parse(daily.time);

      String dayDisplayName;

      if (dateFromData.year == today.year &&
          dateFromData.month == today.month &&
          dateFromData.day == today.day) {
        dayDisplayName = 'Today';
      } else {
        String dayName = DateFormat('EEEE', 'en_US').format(dateFromData);

        dayDisplayName = dayName[0].toUpperCase() + dayName.substring(1);
      }

      final Map<String, String> dailyMap = {
        'time': daily.time,
        'timeDisplay': dayDisplayName,
        'maxTemperature': daily.maxTemperature.toString(),
        'minTemperature': daily.minTemperature.toString(),
        'weatherCode': daily.weatherCode.toString(),
        'weatherCodeDescription': weatherData.getWeatherDescription(
          daily.weatherCode,
        ),
      };

      dailyWeatherMaps.add(dailyMap);
      count++;
    }

    return dailyWeatherMaps;
  }

  Widget _buildDailyWeatherCard(Map<String, String> dailyData, int index) {
    Widget buildTempRow(String iconPath, String? temp) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 16, height: 16),
          const SizedBox(width: 5),
          Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
              children: [
                TextSpan(text: temp ?? '--'),
                const TextSpan(
                  text: '°C',
                  style: TextStyle(color: Colors.white70, fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xff030524),
        borderRadius: BorderRadius.circular(10.0),
        border:
            index == 0
                ? Border.all(width: 2, color: Colors.white54)
                : Border.all(width: 2, color: const Color(0xff11112a)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dailyData['timeDisplay']}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    '${dailyData['time']}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  weatherData.getImageForWeatherCode(
                    dailyData['weatherCode'] ?? '100',
                  ),
                  height: 50,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildTempRow(
                  'assets/icon/thermometer_high.png',
                  dailyData['maxTemperature'],
                ),

                buildTempRow(
                  'assets/icon/thermometer_low.png',
                  dailyData['minTemperature'],
                ),

                Text(
                  dailyData['weatherCodeDescription'] ?? '',
                  style: const TextStyle(fontSize: 14.0, color: Colors.white),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> hourlyWeatherMaps =
        _createDailyWeatherMaps();

    if (hourlyWeatherMaps.isEmpty) {
      return const Center(
        child: Text(
          'Aucune donnée horaire disponible.',
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    const double mobileBreakpoint = 490.0;
    final double viewportFractionValue =
        screenWidth < mobileBreakpoint ? 1.0 : 0.5;

    return CarouselSlider(
      options: CarouselOptions(
        height: 140.0,
        enlargeCenterPage: false,
        autoPlay: false,
        enableInfiniteScroll: false,
        viewportFraction: viewportFractionValue,
        padEnds: false,
      ),
      items:
          hourlyWeatherMaps.asMap().entries.map((entry) {
            final int index = entry.key; // index
            final Map<String, String> dailyData = entry.value;

            return Builder(
              builder: (BuildContext context) {
                return _buildDailyWeatherCard(dailyData, index);
              },
            );
          }).toList(),
    );
  }
}
