import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:country_flags/country_flags.dart';
import '../models/weather_model.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => TodayPageState();
}

class TodayPageState extends State<TodayPage> {
  WeatherData? _weatherData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherData = context.watch<WeatherDataProvider>().weatherData;
  }
  // List<Map<String, String>> hourlyWeatherMaps = [];

  List<Map<String, String>> _createHourlyWeatherMaps() {
    // Vérifiez que _weatherData et hourly ne sont pas null
    if (_weatherData == null || _weatherData!.hourly.isEmpty) {
      return [];
    }

    List<Map<String, String>> hourlyWeatherMaps = [];

    var count = 0;
    for (var hourly in _weatherData!.hourly) {
      if (count >= 24) {
        break;
      }
      Map<String, String> hourlyMap = {
        'time': hourly.time,
        'temperature': hourly.temperature.toString(),
        'weatherCode': hourly.weatherCode.toString(),
        'windSpeed': hourly.windSpeed.toString(),
      };
      hourlyWeatherMaps.add(hourlyMap);
      count++;
    }

    return hourlyWeatherMaps;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 20),
          child: SizedBox(
            height: 30,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CountryFlag.fromCountryCode(
                    _weatherData?.code != null
                        ? _weatherData!.code.toString()
                        : 'fr',
                    height: 30,
                    shape: const RoundedRectangle(0),
                  ),
                ),
                Flexible(
                  // Ajout de Flexible ici
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _weatherData?.country != null
                          ? _weatherData!.country.toString()
                          : 'Unknown',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 22),
                      overflow:
                          TextOverflow
                              .ellipsis, // Important pour gérer l'overflow
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        // Ajout de Flexible ici pour la ville
                        child: Text(
                          _weatherData?.city != null
                              ? _weatherData!.city.toString()
                              : '',
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis, // Important
                        ),
                      ),
                      if (_weatherData?.country != null)
                        const Text(', ', style: TextStyle(fontSize: 18)),
                      Flexible(
                        // Ajout de Flexible ici pour la région
                        child: Text(
                          _weatherData?.region != null
                              ? _weatherData!.region.toString()
                              : '',
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis, // Important
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children:
                  _createHourlyWeatherMaps()
                      .map((map) => _buildCell(map))
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // List<Widget> _buildButtonRows(List<Map<String, String>> buttons) {
  //   List<Widget> rows = [];
  //   for (int i = 0; i < buttons.length; i += 1) {
  //     rows.add(Row(children: _buildRow(buttons, i)));
  //   }
  //   return rows;
  // }

  // List<Widget> _buildRow(List<Map<String, String>> buttons, int startIndex) {
  //   List<Widget> cells = [];
  //   for (int i = startIndex; i < startIndex + 1 && i < buttons.length; i++) {
  //     cells.add(Expanded(child: _buildCell(buttons[i])));
  //   }
  //   return cells;
  // }

  Widget _buildCell(Map<String, String> button) {
    String title = button['time'] ?? '';
    String value = button['temperature'] ?? '';
    String unit = button['windSpeed'] ?? '';

    return ElevatedButton(
      onPressed: () {
        debugPrint('Button pressed: $title');
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(6.0),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          if (value.isNotEmpty)
            Container(
              padding: EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "$value °C",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 25),
                    Text(
                      "$unit m/s",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
