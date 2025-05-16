import 'package:flutter/material.dart';

class DetailedWeatherScreen extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const DetailedWeatherScreen({super.key, required this.weatherData});

  String formatTemperature(dynamic temp) {
    if (temp is num) {
      double t = temp.toDouble();
      if (t > 100) {
        return '${(t - 273.15).round()} °C';
      } else {
        return '${t.round()} °C';
      }
    }
    return 'N/A';
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final main = weatherData['main'] ?? {};
    final wind = weatherData['wind'] ?? {};
    final weatherList = weatherData['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty ? weatherList[0] : {};
    final location = weatherData['name'] ?? 'Unknown Location';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Details'),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white10,
        padding: const EdgeInsets.all(12),
        child: ListView(
          shrinkWrap: true,
          children: [
            // Top card with location, icon, weather main & description
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Image.network(
                      'https://openweathermap.org/img/wn/${weather['icon'] ?? '01d'}@2x.png',
                      width: 100,
                      height: 100,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 60),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${weather['main'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${weather['description'] ?? 'N/A'}'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Temperature card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Temperature',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(height: 20, thickness: 1.2),
                    buildInfoRow(Icons.thermostat_rounded, 'Current', formatTemperature(main['temp'])),
                    buildInfoRow(Icons.thermostat_outlined, 'Feels Like', formatTemperature(main['feels_like'])),
                    buildInfoRow(Icons.opacity, 'Humidity', '${main['humidity'] ?? 'N/A'}%'),
                    buildInfoRow(Icons.speed, 'Pressure', '${main['pressure'] ?? 'N/A'} hPa'),
                  ],
                ),
              ),
            ),

            // Wind card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wind',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(height: 20, thickness: 1.2),
                    buildInfoRow(Icons.air, 'Speed', '${wind['speed'] ?? 'N/A'} m/s'),
                    buildInfoRow(Icons.navigation, 'Direction', '${wind['deg'] ?? 'N/A'}°'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
