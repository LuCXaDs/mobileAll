import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';
import '../models/weather_model.dart';

class WeeklyPage extends StatefulWidget {
  const WeeklyPage({super.key});

  @override
  State<WeeklyPage> createState() => WeeklyPageState();
}

class WeeklyPageState extends State<WeeklyPage> {
  WeatherData? _weatherData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherData = context.watch<WeatherDataProvider>().weatherData;
  }

  List<Map<String, String>> _createHourlyWeatherMaps() {
    // Vérifiez que _weatherData et hourly ne sont pas null
    if (_weatherData == null || _weatherData!.daily.isEmpty) {
      return [];
    }

    List<Map<String, String>> dailyWeatherMaps = [];

    var count = 0;
    for (var daily in _weatherData!.daily) {
      if (count >= 24) {
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

  Widget _buildCell(Map<String, String> button) {
    String title = button['time'] ?? '';
    String value = button['minTemperature'] ?? '';
    String unit = button['maxTemperature'] ?? '';
    String code =
        _weatherData?.getWeatherDescription(
          int.tryParse(button['weatherCode'] ?? '') ?? -1,
        ) ??
        '';

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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    code,
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
                      "min $value °C",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 25),
                    Text(
                      "max $unit °C",
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
