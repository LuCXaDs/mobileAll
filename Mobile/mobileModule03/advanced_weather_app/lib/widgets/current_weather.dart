import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCurrentAllInfo extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherCurrentAllInfo({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Un peu plus arrondi
        color: const Color(0xff11112a),
      ),
      child: Column(
        // On utilise la colonne comme parent principal pour organiser verticalement
        crossAxisAlignment: CrossAxisAlignment.start,
        // Répartit l'espace vertical de manière égale entre le titre et les rangées
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // --- TITRE ---
          Padding(
            padding: EdgeInsetsGeometry.only(bottom: 20),
            child: const Text(
              'Current Weather',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // --- PREMIÈRE RANGÉE D'INFORMATIONS ---
          Row(
            // Répartit l'espace horizontal de manière égale entre les 3 colonnes d'infos
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                title: "Feel Like",
                value: '${weatherData.current.apparentTemperature}°',
              ),
              _buildInfoItem(
                title: "Humidity",
                value: '${weatherData.current.humidity}%',
              ),
              _buildInfoItem(
                title: "Precipitation",
                value: '${weatherData.current.precipitation} mm',
              ),
            ],
          ),
          SizedBox(height: 30),
          // --- DEUXIÈME RANGÉE D'INFORMATIONS ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                title: "Wind Speed",
                value: '${weatherData.current.windSpeed} m/s',
              ),
              _buildInfoItem(
                title: "UV Index",
                value: '${weatherData.current.uvIndex}',
              ),
              _buildInfoItem(
                title: "Pressure",
                value: '${weatherData.current.pressure} hPa',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Une méthode privée "helper" pour construire un item d'information.
  /// Cela évite la répétition de code et rend le widget principal plus lisible.
  Widget _buildInfoItem({required String title, required String value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14, // Légèrement plus grand pour la lisibilité
            color: Colors.white54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5), // Ajoute un petit espace vertical
        Text(
          value,
          style: const TextStyle(
            fontSize: 16, // La valeur un peu plus grande que le titre
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
