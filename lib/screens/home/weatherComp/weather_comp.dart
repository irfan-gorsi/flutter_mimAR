import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final double temperature; // can be Kelvin or Celsius
  final double feelsLike;   // can be Kelvin or Celsius
  final String description;
  final String iconCode;
  final VoidCallback? onTap;

  const WeatherCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    this.onTap,
  });

  String formatTemperature(double temp) {
    if (temp > 100) {
      // Probably Kelvin, convert to Celsius
      return (temp - 273.15).round().toString();
    } else {
      // Probably Celsius, just round
      return temp.round().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: const Color.fromARGB(141, 33, 33, 33),  // Dark grey background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.network(
                'http://openweathermap.org/img/wn/$iconCode@2x.png',
                width: 60,
                height: 60,
                color: Colors.white,  // Tint icon white to match theme
                colorBlendMode: BlendMode.srcIn,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,  // White text
                    ),
                  ),
                  Text(
                    '${formatTemperature(temperature)} °C',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,  // Slightly transparent white
                    ),
                  ),
                  Text(
                    'Feels like: ${formatTemperature(feelsLike)} °C',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white54,  // More transparent white
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
