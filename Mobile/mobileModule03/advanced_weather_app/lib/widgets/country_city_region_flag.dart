import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';

import '../models/weather_model.dart';

class CountryCityRegionFlag extends StatelessWidget {
  final WeatherData weatherData;

  const CountryCityRegionFlag({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CountryFlag.fromCountryCode(
              weatherData.code.toString(),
              height: 18,
              width: 24,
              shape: const RoundedRectangle(0),
            ),
          ),
          Flexible(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                weatherData.country.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow:
                    TextOverflow.ellipsis, // Important pour gérer l'overflow
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    weatherData.city.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (weatherData.city == 'Unknown')
                  Flexible(
                    child: Text(
                      weatherData.region.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (weatherData.city != 'Unknown')
                  Flexible(
                    child: Text(
                      ', ${weatherData.region.toString()}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
