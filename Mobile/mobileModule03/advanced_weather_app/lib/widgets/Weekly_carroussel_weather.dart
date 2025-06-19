import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class WeeklyCarrousselWeather extends StatelessWidget {
  final WeatherData weatherData;

  const WeeklyCarrousselWeather({super.key, required this.weatherData});

  List<Map<String, String>> _createHourlyWeatherMaps() {
    // Vérifiez que _weatherData et hourly ne sont pas null
    if (_weatherData == null || _weatherData!.daily.isEmpty) {
      return [];
    }

    List<Map<String, String>> dailyWeatherMaps = [];

    var count = 0;
    for (var daily in _weatherData!.daily) {
      if (count > 7) {
        break;
      }
      Map<String, String> hourlyMap = {
        'time': daily.time,
        'maxTemperature': daily.maxTemperature.toString(),
        'minTemperature': daily.minTemperature.toString(),
        'weatherCode': daily.weatherCode.toString(),
      };
      dailyWeatherMaps.add(hourlyMap);
      count++;
    }

    return dailyWeatherMaps;
  }

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

  Widget _buildHourlyWeatherCard(Map<String, String> hourlyData) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
        border: BoxBorder.all(
          width: 2,
          color: const Color(0xff11112a),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
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
            ],
          ),

          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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

    // Si tu veux exactement 3 conteneurs, assure-toi que ta liste a au moins 3 éléments.
    // Sinon, le carrousel affichera le nombre d'éléments disponibles.
    // Tu peux ajouter une logique ici pour garantir 3 éléments si nécessaire,
    // par exemple en remplissant avec des données "N/A" si weatherData.hourly est trop court.
    // Pour l'instant, on suppose que weatherData.hourly contient au moins 3 éléments.

    return CarouselSlider(
      options: CarouselOptions(
        height: 120.0,
        enlargeCenterPage: false,
        // --- Nouveaux paramètres pour contrôler le comportement ---
        autoPlay: false, // Désactive l'auto-lecture
        enableInfiniteScroll: false, // Désactive le défilement infini
        // --- Fin des nouveaux paramètres ---
        // autoPlayInterval: const Duration(seconds: 3),
        // autoPlayAnimationDuration: const Duration(milliseconds: 100),
        // autoPlayCurve: Curves.fastOutSlowIn,
        viewportFraction: 1 / 2,
        padEnds: false,
      ),
      items:
          hourlyWeatherMaps.map((hourlyData) {
            return Builder(
              builder: (BuildContext context) {
                return _buildHourlyWeatherCard(hourlyData);
              },
            );
          }).toList(),
    );
  }
}
