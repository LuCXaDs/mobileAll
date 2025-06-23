import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math'; // Import de la bibliothèque mathématique pour simuler la température
import 'package:intl/intl.dart';

import '../models/weather_model.dart';

/// Modèle de données pour les points du graphique.
/// Chaque point aura une heure et une température associée.
class TemperatureData {
  final String hour; // L'heure au format "00h", "01h", etc.
  final double temperature; // La température correspondante

  TemperatureData(this.hour, this.temperature);
}

class TemperatureChartPage extends StatelessWidget {
  final WeatherData weatherData;

  const TemperatureChartPage({super.key, required this.weatherData});

  List<TemperatureData> _getChartDataFromApi(WeatherData weatherData) {
    final List<TemperatureData> chartData = [];

    // Sécurité : si les données horaires sont vides, on retourne une liste vide.
    if (weatherData.hourly.isEmpty) {
      return chartData;
    }

    // On ne prend que les 24 premières heures de prévisions.
    final hourlyForecasts = weatherData.hourly.take(24);

    for (var hourly in hourlyForecasts) {
      try {
        // 1. On parse la date depuis la chaîne de caractères (ex: "2023-10-27T14:00")
        final DateTime dateTime = DateTime.parse(hourly.time);

        // 2. On formate l'heure pour l'axe X du graphique (ex: "14h")
        final String formattedHour = "${DateFormat('HH').format(dateTime)}h";

        // 3. On s'assure que la température est un double
        final double temperature = hourly.temperature.toDouble();

        // 4. On ajoute les données formatées à notre liste pour le graphique
        chartData.add(TemperatureData(formattedHour, temperature));
      } catch (e) {
        // Si une date est mal formatée, on l'ignore et on continue
        debugPrint(
          "Erreur de parsing de la date/heure : ${hourly.time}, erreur: $e",
        );
      }
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff030524),
        border: Border.all(width: 2, color: Colors.white54.withAlpha(50)),
        borderRadius: BorderRadius.circular(10.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.2),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      // Le fond de l'application doit être sombre pour que le texte blanc soit visible
      // Par exemple, placez ce widget dans un Scaffold avec un backgroundColor: Colors.black
      child: SfCartesianChart(
        // --- Configuration générale du graphique ---
        backgroundColor: Colors.transparent,
        plotAreaBackgroundColor: Colors.transparent,
        plotAreaBorderWidth: 0,

        // MODIFIÉ : Le titre principal a été supprimé.
        title: ChartTitle(
          text: 'Température sur 24h',
          textStyle: TextStyle(color: Colors.white),
          alignment: ChartAlignment.near,
        ),

        // --- Configuration de l'axe X (Heures) ---
        primaryXAxis: CategoryAxis(
          // MODIFIÉ : Affiche une étiquette toutes les 2 heures.
          interval: 4,
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          // MODIFIÉ : Style du texte des étiquettes en blanc.
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),

        // --- Configuration de l'axe Y (Températures) ---
        primaryYAxis: NumericAxis(
          // MODIFIÉ : Le titre de l'axe a été supprimé.
          // title: AxisTitle(text: 'Température (°C)'),
          labelFormat: '{value}°', // Format plus simple sans 'C'
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          // MODIFIÉ : Style du texte des étiquettes en blanc.
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),

        // --- Configuration de la série de données ---
        // REMPLACÉ : LineSeries est remplacée par AreaSeries pour une courbe pleine.
        series: <CartesianSeries<TemperatureData, String>>[
          AreaSeries<TemperatureData, String>(
            dataSource: _getChartDataFromApi(weatherData),
            xValueMapper: (TemperatureData data, _) => data.hour,
            yValueMapper: (TemperatureData data, _) => data.temperature,

            // NOUVEAU : Définit un dégradé pour le remplissage.
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.4),
                Colors.blueAccent.withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),

            // NOUVEAU : Ajoute une ligne de bordure en haut de la zone pleine.
            borderColor: Colors.blueAccent.withAlpha(50),
            borderWidth: 2,

            // markerSettings: const MarkerSettings(
            //   isVisible: true,
            //   color: Colors.white,
            //   borderColor: Colors.blueAccent,
            //   borderWidth: 2,
            // ),

            // MODIFIÉ : Les étiquettes de données sont toujours visibles et en blanc.
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              labelAlignment: ChartDataLabelAlignment.top,
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
        legend: const Legend(isVisible: false),
      ),
    );
  }
}
