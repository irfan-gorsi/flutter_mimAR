import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final double temperature; // Kelvin or Celsius
  final double feelsLike;   // Kelvin or Celsius
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
      return (temp - 273.15).round().toString();
    } else {
      return temp.round().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Image.network(
                'https://openweathermap.org/img/wn/$iconCode@2x.png',
                width: 60,
                height: 60,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatTemperature(temperature)} °C',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Feels like: ${formatTemperature(feelsLike)} °C',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      description.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
