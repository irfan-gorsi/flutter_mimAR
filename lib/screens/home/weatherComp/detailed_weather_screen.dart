import 'package:flutter/material.dart';

class DetailedWeatherScreen extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const DetailedWeatherScreen({super.key, required this.weatherData});

  String formatTemperature(dynamic temp) {
    if (temp is num) {
      double t = temp.toDouble();
      if (t > 100) {
        return '${(t - 273.15).round()}°C';
      } else {
        return '${t.round()}°C';
      }
    }
    return 'N/A';
  }

  String getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    if (hour < 21) return 'Evening';
    return 'Night';
  }

  Color getBackgroundColor(String weatherCondition) {
    return const Color(0xFF4A90E2);
  }

  Widget buildWeatherInfoCard(String title, List<Map<String, dynamic>> items) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => buildInfoRow(
              item['icon'],
              item['label'],
              item['value'],
              iconColor: item['iconColor'], 
            )),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value, {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? const Color(0xFF3498DB)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor ?? const Color(0xFF3498DB), size: 22),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF2C3E50),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
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
    final weatherMain = weather['main'] ?? 'Clear';
    final bgColor = getBackgroundColor(weatherMain);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bgColor,
              bgColor.withOpacity(0.8),
              bgColor.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Weather Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                      color: Color(0x55000000),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Good ${getTimeOfDay()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formatTemperature(main['temp']),
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -1,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Color(0x55000000),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.network(
                              'https://openweathermap.org/img/wn/${weather['icon'] ?? '01d'}@4x.png',
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.wb_sunny,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather['main'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '${weather['description'] ?? 'N/A'}'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Feels like ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                Text(
                                  formatTemperature(main['feels_like']),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      children: [
                        buildWeatherInfoCard(
                          'Temperature Details',
                          [
                            {
                              'icon': Icons.thermostat_rounded,
                              'label': 'Current',
                              'value': formatTemperature(main['temp']),
                              'iconColor': Colors.orange,
                            },
                            {
                              'icon': Icons.thermostat_outlined,
                              'label': 'Feels Like',
                              'value': formatTemperature(main['feels_like']),
                              'iconColor': Colors.red,
                            },
                            {
                              'icon': Icons.arrow_upward,
                              'label': 'Maximum',
                              'value': formatTemperature(main['temp_max']),
                              'iconColor': Colors.red,
                            },
                            {
                              'icon': Icons.arrow_downward,
                              'label': 'Minimum',
                              'value': formatTemperature(main['temp_min']),
                              'iconColor': Colors.blue,
                            },
                          ],
                        ),
                        buildWeatherInfoCard(
                          'Atmospheric Conditions',
                          [
                            {
                              'icon': Icons.opacity,
                              'label': 'Humidity',
                              'value': '${main['humidity'] ?? 'N/A'}%',
                              'iconColor': Colors.blue,
                            },
                            {
                              'icon': Icons.speed,
                              'label': 'Pressure',
                              'value': '${main['pressure'] ?? 'N/A'} hPa',
                              'iconColor': Colors.purple,
                            },
                            {
                              'icon': Icons.visibility,
                              'label': 'Visibility',
                              'value': '${(weatherData['visibility'] ?? 0) / 1000} km',
                              'iconColor': Colors.grey,
                            },
                          ],
                        ),
                        buildWeatherInfoCard(
                          'Wind Information',
                          [
                            {
                              'icon': Icons.air,
                              'label': 'Speed',
                              'value': '${wind['speed'] ?? 'N/A'} m/s',
                              'iconColor': Colors.teal,
                            },
                            {
                              'icon': Icons.navigation,
                              'label': 'Direction',
                              'value': '${wind['deg'] ?? 'N/A'}°',
                              'iconColor': Colors.indigo,
                            },
                            {
                              'icon': Icons.waves,
                              'label': 'Gust',
                              'value': '${wind['gust'] ?? 'N/A'} m/s',
                              'iconColor': Colors.blueGrey,
                            },
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
