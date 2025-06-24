import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherInfoRow extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherInfoRow({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double mobileBreakpoint = 490.0;
    final bool viewportFractionValue =
        screenWidth > mobileBreakpoint ? true : false;

    return Container(
      height: 100,
      padding: EdgeInsets.only(right: 5, left: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Image.asset(
              weatherData.getImageForWeatherCode(
                weatherData.current.weatherCode.toString(),
              ),
              width: 70,
              height: 70,
            ),
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                '${weatherData.current.temperature}',
                style: const TextStyle(
                  fontSize: 200,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          if (viewportFractionValue)
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
                  'Feel like ${weatherData.current.apparentTemperature}°',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Wind Speed ${weatherData.current.windSpeed} m/s',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
