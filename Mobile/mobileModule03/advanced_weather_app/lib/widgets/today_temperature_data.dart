import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math'; // Import de la bibliothèque mathématique pour simuler la température

/// Modèle de données pour les points du graphique.
/// Chaque point aura une heure et une température associée.
class TemperatureData {
  final String hour; // L'heure au format "00h", "01h", etc.
  final double temperature; // La température correspondante

  TemperatureData(this.hour, this.temperature);
}

class TemperatureChartPage extends StatelessWidget {
  const TemperatureChartPage({super.key});

  /// Méthode pour générer des données de température factices sur 24 heures.
  /// La température suit une courbe sinusoïdale pour simuler le cycle jour/nuit.
  List<TemperatureData> _getChartData() {
    final List<TemperatureData> chartData = [];
    // Boucle pour générer des données pour chaque heure de 00h à 23h
    for (int i = 0; i < 24; i++) {
      // Simule une variation de température réaliste au cours de la journée
      // Température de base de 12°C, avec une amplitude de 6°C.
      // Le pic de température est à 15h (15:00).
      final double temperature = 12 + (6 * cos((i - 15) * (pi * 2) / 24));

      // Formate l'heure avec un zéro initial si nécessaire (ex: "01h", "08h")
      final String hour = '${i.toString().padLeft(2, '0')}h';

      chartData.add(
        TemperatureData(hour, double.parse(temperature.toStringAsFixed(1))),
      );
    }
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: const Color(0xff11112a),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
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
            dataSource: _getChartData(),
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
