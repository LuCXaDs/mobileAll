import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class TodayCarrousselWeather extends StatelessWidget {
  final WeatherData weatherData;

  const TodayCarrousselWeather({super.key, required this.weatherData});

  List<Map<String, String>> _createHourlyWeatherMaps() {
    List<Map<String, String>> hourlyWeatherMaps = [];

    var count = 0;
    for (var hourly in weatherData.hourly) {
      if (count >= 24) {
        break;
      }
      DateTime dateTime = DateTime.parse(hourly.time);

      String formattedTime = DateFormat('HH:mm').format(dateTime);

      Map<String, String> hourlyMap = {
        'time': formattedTime,
        'temperature': hourly.temperature.toString(),
        'weatherCodeDescription': weatherData.getWeatherDescription(
          hourly.weatherCode,
        ),
        'weatherCode': hourly.weatherCode.toString(),
        'windSpeed': hourly.windSpeed.toString(),
      };
      hourlyWeatherMaps.add(hourlyMap);
      count++;
    }

    return hourlyWeatherMaps;
  }

  Widget _buildHourlyWeatherCard(Map<String, String> hourlyData, int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: const Color(0xff11112a),
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
            index != weatherData.time.hour
                ? BoxBorder.all(
                  width: 2,
                  color: Color(0xff11112a),
                  style: BorderStyle.solid,
                )
                : BoxBorder.all(
                  width: 2,
                  color: Colors.white54,
                  style: BorderStyle.solid,
                ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText(
            '${hourlyData['time']}',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: Image.asset(
              weatherData.getImageForWeatherCode(
                hourlyData['weatherCode'] ?? '100',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Image.asset(
                'assets/icon/8726417_temperature_half_icon.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 5),
              SelectableText(
                '${hourlyData['temperature']}',
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),

              SelectableText(
                '°C',
                style: const TextStyle(fontSize: 12.0, color: Colors.white70),
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
                'assets/icon/8726449_wind_icon.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 5),

              SelectableText(
                '${hourlyData['windSpeed']}',
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),

              SelectableText(
                'km/h',
                style: const TextStyle(fontSize: 12.0, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // const SizedBox(height: 5),
          // SelectableText(
          //   'Code Météo: ${hourlyData['weatherCode']}',
          //   style: const TextStyle(fontSize: 16.0, color: Colors.white),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> hourlyWeatherMaps =
        _createHourlyWeatherMaps();

    if (hourlyWeatherMaps.isEmpty) {
      return const Center(
        child: Text(
          'Aucune donnée horaire disponible.',
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      );
    }

    // int getHourFromDateTime(DateTime dateTime) {
    //   return dateTime.hour;

    // Si tu veux exactement 3 conteneurs, assure-toi que ta liste a au moins 3 éléments.
    // Sinon, le carrousel affichera le nombre d'éléments disponibles.
    // Tu peux ajouter une logique ici pour garantir 3 éléments si nécessaire,
    // par exemple en remplissant avec des données "N/A" si weatherData.hourly est trop court.
    // Pour l'instant, on suppose que weatherData.hourly contient au moins 3 éléments.

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: false,
        initialPage: weatherData.time.hour,
        // --- Nouveaux paramètres pour contrôler le comportement ---
        autoPlay: false, // Désactive l'auto-lecture
        enableInfiniteScroll: false, // Désactive le défilement infini
        // --- Fin des nouveaux paramètres ---
        // autoPlayInterval: const Duration(seconds: 3),
        // autoPlayAnimationDuration: const Duration(milliseconds: 100),
        // autoPlayCurve: Curves.fastOutSlowIn,
        viewportFraction: 1 / 3,
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
                return _buildHourlyWeatherCard(dailyData, index);
              },
            );
          }).toList(),
    );
  }
}
