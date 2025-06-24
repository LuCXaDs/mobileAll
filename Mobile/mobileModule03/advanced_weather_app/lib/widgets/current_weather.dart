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
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xff11112a),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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

          Row(
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

  Widget _buildInfoItem({required String title, required String value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
