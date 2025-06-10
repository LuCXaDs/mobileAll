import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../models/app_state.dart';
import '../models/weather_model.dart';
import 'package:country_flags/country_flags.dart';

class CurrentlyPage extends StatefulWidget {
  const CurrentlyPage({super.key});

  @override
  State<CurrentlyPage> createState() => CurrentlyPageState();
}

class CurrentlyPageState extends State<CurrentlyPage> {
  WeatherData? _weatherData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherData = context.watch<WeatherDataProvider>().weatherData;
    debugPrint(
      '[CurrentlyPage] didChangeDependencies, weatherData: $_weatherData',
    );
  }

  List<Map<String, String>> _initializeButtons() {
    if (_weatherData != null) {
      List<Map<String, String>> buttons = [
        {
          'title': 'Real Feel',
          'value': _weatherData!.current.apparentTemperature.toString(),
          'unit': ' °C',
        },
        {
          'title': 'Humidity',
          'value': _weatherData!.current.humidity.toString(),
          'unit': ' %',
        },
        {
          'title': 'Pressure',
          'value': _weatherData!.current.pressure.toString(),
          'unit': ' hPa',
        },
        {
          'title': 'Wind',
          'value': _weatherData!.current.windSpeed.toString(),
          'unit': ' m/s',
        },
        {
          'title': 'UV index',
          'value': _weatherData!.current.uvIndex.toString(),
          'unit': '',
        },
        {
          'title': 'Precipitation',
          'value': _weatherData!.current.precipitation.toString(),
          'unit': ' mm',
        },
      ];
      return buttons;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[CurrentlyPage] Build appelé, weatherData: $_weatherData');
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(right: 30, left: 30, top: 30),
            child: Column(
              children: [
                Flexible(
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
                                const Text(
                                  ', ',
                                  style: TextStyle(fontSize: 18),
                                ),
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
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Currently',
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                _weatherData?.current.temperature != null
                                    ? _weatherData?.getWeatherDescription(
                                          _weatherData!.current.weatherCode,
                                        ) ??
                                        'no'
                                    : '',
                                style: TextStyle(fontSize: 22),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Flexible(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _weatherData?.current.temperature != null
                          ? '${_weatherData!.current.temperature.toString()}°'
                          : 'Non',
                      style: TextStyle(fontSize: 200),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: _buildButtonRows(_initializeButtons()),
          ),
        ),
      ],
    );
  }

  // List<Widget> _buildButtonRows(List<Map<String, String>> buttons) {
  //   List<Widget> rows = [];
  //   for (int i = 0; i < buttons.length; i += 2) {
  //     rows.add(Row(children: _buildRow(buttons, i)));
  //   }
  //   return rows;
  // }

  // List<Widget> _buildRow(List<Map<String, String>> buttons, int startIndex) {
  //   List<Widget> cells = [];
  //   for (int i = startIndex; i < startIndex + 2 && i < buttons.length; i++) {
  //     cells.add(Expanded(child: _buildCell(buttons[i])));
  //   }
  //   return cells;
  // }
  Widget _buildButtonRows(List<Map<String, String>> buttons) {
    List<Widget> rows = [];
    for (int i = 0; i < buttons.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(child: _buildCell(buttons[i])),
            if (i + 1 < buttons.length)
              Expanded(child: _buildCell(buttons[i + 1])),
            if (buttons.length % 2 != 0 && i == buttons.length - 1)
              const Expanded(
                child: SizedBox(),
              ), // Pour aligner le dernier élément si nombre impair
          ],
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildCell(Map<String, String> button) {
    String title = button['title'] ?? '';
    String value = button['value'] ?? '';
    String unit = button['unit'] ?? '';

    return ElevatedButton(
      onPressed: () {
        debugPrint('Button pressed: $title');
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(6.0),
        backgroundColor: Colors.transparent,
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
                  // color: Colors.black87,
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
                      value,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        // color: Colors.black54,
                      ),
                    ),
                    Text(
                      unit,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        // color: Colors.black45,
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
