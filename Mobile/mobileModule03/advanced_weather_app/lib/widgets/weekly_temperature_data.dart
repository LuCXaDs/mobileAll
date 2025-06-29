import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/weather_model.dart';

class DailyTemperatureData {
  final String day;
  final double minTemp;
  final double maxTemp;

  DailyTemperatureData(this.day, this.minTemp, this.maxTemp);
}

class DailyTemperatureChart extends StatelessWidget {
  final WeatherData weatherData;

  const DailyTemperatureChart({super.key, required this.weatherData});

  List<DailyTemperatureData> _getDailyChartData() {
    final List<DailyTemperatureData> chartData = [];
    if (weatherData.daily.isEmpty) return chartData;

    final dailyForecasts = weatherData.daily.take(7);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var daily in dailyForecasts) {
      try {
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

        final double minTemp = daily.minTemperature.toDouble();
        final double maxTemp = daily.maxTemperature.toDouble();

        chartData.add(DailyTemperatureData(dayDisplayName, minTemp, maxTemp));
      } catch (e) {
        debugPrint(
          "Erreur de parsing de la date journalière : ${daily.time}, erreur: $e",
        );
      }
    }
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    final List<DailyTemperatureData> chartDataSource = _getDailyChartData();

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
          text: '7 Days Temperature Min/Max',
          textStyle: const TextStyle(color: Colors.white),
          alignment: ChartAlignment.near,
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
          labelRotation: -45,
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}°',
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        series: <CartesianSeries<DailyTemperatureData, String>>[
          // --- Temperature MAXIMALE ---
          AreaSeries<DailyTemperatureData, String>(
            name: 'Maximun Temperature',
            dataSource: chartDataSource,
            xValueMapper: (DailyTemperatureData data, _) => data.day,
            yValueMapper: (DailyTemperatureData data, _) => data.maxTemp,
            gradient: LinearGradient(
              colors: [
                Colors.redAccent.withOpacity(0.5),
                Colors.redAccent.withOpacity(0.2),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderColor: Colors.redAccent,
            borderWidth: 2,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              margin: EdgeInsets.only(top: 5),
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // --- Temperature MINIMALE ---
          AreaSeries<DailyTemperatureData, String>(
            name: 'Minimun temperature',
            dataSource: chartDataSource,
            xValueMapper: (DailyTemperatureData data, _) => data.day,
            yValueMapper: (DailyTemperatureData data, _) => data.minTemp,
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.5),
                Colors.blueAccent.withOpacity(0.2),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderColor: Colors.blueAccent,
            borderWidth: 2,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.bottom,
              margin: EdgeInsets.only(top: 5),
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}
