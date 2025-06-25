import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';

class TemperatureData {
  final String hour;
  final double temperature;

  TemperatureData(this.hour, this.temperature);
}

class TemperatureChartPage extends StatelessWidget {
  final WeatherData weatherData;

  const TemperatureChartPage({super.key, required this.weatherData});

  List<TemperatureData> _getChartDataFromApi(WeatherData weatherData) {
    final List<TemperatureData> chartData = [];

    if (weatherData.hourly.isEmpty) {
      return chartData;
    }

    final hourlyForecasts = weatherData.hourly.take(24);

    for (var hourly in hourlyForecasts) {
      try {
        final DateTime dateTime = DateTime.parse(hourly.time);

        final String formattedHour = "${DateFormat('HH').format(dateTime)}h";

        final double temperature = hourly.temperature.toDouble();

        chartData.add(TemperatureData(formattedHour, temperature));
      } catch (e) {
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
      ),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        plotAreaBackgroundColor: Colors.transparent,
        plotAreaBorderWidth: 0,

        title: ChartTitle(
          text: '24h Temperature',
          textStyle: TextStyle(color: Colors.white),
          alignment: ChartAlignment.near,
        ),

        // --- Configuration X (Hours) ---
        primaryXAxis: CategoryAxis(
          interval: 4,
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),

        // --- Configuration Y (Temperature) ---
        primaryYAxis: NumericAxis(
          labelFormat: '{value}°',
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),

        series: <CartesianSeries<TemperatureData, String>>[
          AreaSeries<TemperatureData, String>(
            dataSource: _getChartDataFromApi(weatherData),
            xValueMapper: (TemperatureData data, _) => data.hour,
            yValueMapper: (TemperatureData data, _) => data.temperature,

            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.4),
                Colors.blueAccent.withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),

            borderColor: Colors.blueAccent.withAlpha(50),
            borderWidth: 2,

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
