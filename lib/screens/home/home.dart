import 'package:flutter/material.dart';
import 'package:mimar/screens/home/weatherComp/detailed_weather_screen.dart';
import 'package:mimar/screens/home/weatherComp/weather_comp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mimar/screens/home/weatherComp/weather_controller.dart'; // Adjust import as needed

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherController _weatherController = WeatherController();
  Map<String, dynamic>? _weatherData;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weather = await _weatherController.fetchWeather();
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Make sure key matches how you saved it
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : Column(
                  children: [
                    if (_weatherData != null)
                      WeatherCard(
                        city: _weatherData!['name'],
                        temperature: _weatherData!['main']['temp'],
                        feelsLike: _weatherData!['main']['feels_like'],
                        description: _weatherData!['weather'][0]['description'],
                        iconCode: _weatherData!['weather'][0]['icon'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailedWeatherScreen(
                                  weatherData: _weatherData!),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 20),
                    const Center(
                      child: Text('Welcome to the Home Screen!'),
                    ),
                    // Add more widgets below as needed
                  ],
                ),
    );
  }
}
