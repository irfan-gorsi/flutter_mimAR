import 'package:flutter/material.dart';
import 'package:mimar/screens/home/AllUsers/user_table.dart';
import 'package:mimar/screens/home/QuoteComp/quote_controller.dart';
import 'package:mimar/screens/home/QuoteComp/quotecard.dart';
import 'package:mimar/screens/home/gemini/chat_screen';
import 'package:mimar/screens/home/weatherComp/detailed_weather_screen.dart';
import 'package:mimar/screens/home/weatherComp/weather_comp.dart';
import 'package:mimar/screens/home/weatherComp/weather_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherController _weatherController = WeatherController();
  final QuoteController _quoteController = QuoteController();

  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? _quoteData;

  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    try {
      final weather = await _weatherController.fetchWeather();
      final quote = await _quoteController.fetchQuote();

      setState(() {
        _weatherData = weather;
        _quoteData = quote;
        _errorMessage = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'mimAR.',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_weatherData != null)
                        WeatherCard(
                          city: _weatherData!['name'],
                          temperature: _weatherData!['main']['temp'],
                          feelsLike: _weatherData!['main']['feels_like'],
                          description: _weatherData!['weather'][0]
                              ['description'],
                          iconCode: _weatherData!['weather'][0]['icon'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailedWeatherScreen(
                                  weatherData: _weatherData!,
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      if (_quoteData != null)
                        QuoteCard(
                          text: _quoteData!['content'] ?? 'No quote available',
                          author: _quoteData!['author'] ?? 'Unknown',
                        ),
                      const SizedBox(height: 20),
                      const UserTable(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
         backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.smart_toy,color: Colors.white,), 
        onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AiChatScreen()));
                    }
      ),
    );
  }
}
