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

      // Convertit la chaîne de caractères de la date (ex: "2025-06-20") en objet DateTime
      final DateTime dateFromData = DateTime.parse(daily.time);

      String dayDisplayName;

      // Compare la date des données météo avec la date d'aujourd'hui
      if (dateFromData.year == today.year &&
          dateFromData.month == today.month &&
          dateFromData.day == today.day) {
        dayDisplayName = 'Today';
      } else {
        // Formate la date pour obtenir le nom complet du jour de la semaine (ex: "lundi")
        // 'EEEE' est le pattern pour le nom complet du jour. 'fr_FR' pour le français.
        String dayName = DateFormat('EEEE', 'en_US').format(dateFromData);

        // Met la première lettre en majuscule pour un affichage plus propre (ex: "Lundi")
        dayDisplayName = dayName[0].toUpperCase() + dayName.substring(1);
      }

      final Map<String, String> dailyMap = {
        // Utilise le nom formaté du jour au lieu de la date brute
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

  // List<Map<String, String>> _createHourlyWeatherMaps() {
  //   List<Map<String, String>> hourlyWeatherMaps = [];

  //   var count = 0;
  //   for (var hourly in weatherData.hourly) {
  //     if (count >= 24) {
  //       break;
  //     }
  //     DateTime dateTime = DateTime.parse(hourly.time);

  //     String formattedTime = DateFormat('HH:mm').format(dateTime);

  //     Map<String, String> hourlyMap = {
  //       'time': formattedTime,
  //       'temperature': hourly.temperature.toString(),
  //       'weatherCodeDescription': weatherData.getWeatherDescription(
  //         hourly.weatherCode,
  //       ),
  //       'weatherCode': hourly.weatherCode.toString(),
  //       'windSpeed': hourly.windSpeed.toString(),
  //     };
  //     hourlyWeatherMaps.add(hourlyMap);
  //     count++;
  //   }

  //   return hourlyWeatherMaps;
  // }

  Widget _buildDailyWeatherCard(Map<String, String> dailyData, int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff030524),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border:
            index == 0
                ? BoxBorder.all(
                  width: 2,
                  color: Colors.white54,
                  style: BorderStyle.solid,
                )
                : BoxBorder.all(
                  width: 2,
                  color: Color(0xff11112a),
                  style: BorderStyle.solid,
                ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SelectableText(
                '${dailyData['timeDisplay']}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              SelectableText(
                '${dailyData['time']}',
                style: const TextStyle(fontSize: 12.0, color: Colors.white54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 60,
                child: Image.asset(
                  weatherData.getImageForWeatherCode(
                    dailyData['weatherCode'] ?? '100',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // textBaseline: TextBaseline.alphabetic,
                children: [
                  Image.asset(
                    'assets/icon/9045082_temperature_max_icon.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 5),
                  SelectableText(
                    '${dailyData['maxTemperature']}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),

                  SelectableText(
                    '°C',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Image.asset(
                    'assets/icon/9045188_temperature_min_icon.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 5),

                  SelectableText(
                    '${dailyData['minTemperature']}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),

                  SelectableText(
                    '°C',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // textBaseline: TextBaseline.alphabetic,

                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    '${dailyData['weatherCodeDescription']}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
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

    return CarouselSlider(
      options: CarouselOptions(
        height: 140.0,
        enlargeCenterPage: false,
        autoPlay: false,
        enableInfiniteScroll: false,
        viewportFraction: 1 / 2,
        padEnds: false,
      ),
      items:
          hourlyWeatherMaps.asMap().entries.map((entry) {
            final int index = entry.key; // L'index de l'élément actuel
            final Map<String, String> dailyData =
                entry.value; // La donnée elle-même

            return Builder(
              builder: (BuildContext context) {
                // Tu passes maintenant l'index à ta fonction _buildDailyWeatherCard
                return _buildDailyWeatherCard(dailyData, index);
              },
            );
          }).toList(),
    );
  }
}
