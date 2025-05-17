
import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final double temperature;
  final double feelsLike;
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

  Color _getCardColor() {
    return const Color(0xFF5E9EF2); // Default blue
  }

  LinearGradient _getGradient() {
    final baseColor = _getCardColor();
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        baseColor,
        Color.lerp(baseColor, Colors.black, 0.2)!,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: _getGradient(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _getCardColor().withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background patterns (optional subtle weather patterns)
              Positioned(
                right: -20,
                top: -20,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              
              // Main content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              city,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        // Weather condition badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            description.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Main info row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Weather icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            'https://openweathermap.org/img/wn/$iconCode@2x.png',
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.wb_sunny,
                                size: 40,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 20),
                        
                        // Temperature info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatTemperature(temperature),
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    '°C',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              
                              Text(
                                'Feels like: ${formatTemperature(feelsLike)}°C',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Add a subtle overlay pattern
              Positioned(
                bottom: -50,
                right: -50,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}