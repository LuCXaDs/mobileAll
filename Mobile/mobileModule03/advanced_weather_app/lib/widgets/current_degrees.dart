import 'package:flutter/material.dart';
import '../models/weather_model.dart';

/// Un widget qui affiche les informations météo principales sur une seule ligne.
///
/// Ce widget est conçu pour être flexible et s'adapter à l'espace disponible,
/// en alignant l'icône à gauche, la température au centre et les détails à droite.
class WeatherInfoRow extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherInfoRow({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.only(right: 5, left: 5),
      child: Row(
        // C'est la propriété clé pour l'alignement !
        // Elle place le premier élément à gauche, le dernier à droite,
        // et l'élément du milieu sera centré avec l'espace réparti autour.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Élément de Gauche (Image) ---
          // Pas besoin de Flexible ou Align ici, le Row s'en charge.
          Image.asset(
            weatherData.getImageForWeatherCode(
              weatherData.current.weatherCode.toString(),
            ),
            width: 70,
            height: 70,
          ),

          // --- Élément du Centre (Température) ---
          // Le FittedBox est une excellente idée pour que le texte s'adapte
          // sans déborder. Il va prendre l'espace disponible au centre.
          Flexible(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                '${weatherData.current.temperature}',
                style: const TextStyle(
                  fontSize: 200, // Une grande taille de base
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // --- Élément de Droite (Détails) ---
          // Une colonne pour organiser les informations textuelles.
          // CrossAxisAlignment.end alignera le texte à droite, ce qui est
          // plus esthétique pour un bloc positionné à droite de l'écran.
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                weatherData.getWeatherDescription(
                  weatherData.current.weatherCode,
                ),
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Ressenti ${weatherData.current.apparentTemperature}°',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Vent ${weatherData.current.windSpeed} m/s',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
