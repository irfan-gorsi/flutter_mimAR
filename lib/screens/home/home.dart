
import 'package:flutter/material.dart';
import 'package:mimar/screens/home/AllUsers/user_table.dart';
import 'package:mimar/screens/home/QuoteComp/quote_controller.dart';
import 'package:mimar/screens/home/QuoteComp/quotecard.dart';
import 'package:mimar/screens/home/gemini/chat_screen';
import 'package:mimar/screens/home/weatherComp/detailed_weather_screen.dart';
import 'package:mimar/screens/home/weatherComp/weather_comp.dart';
import 'package:mimar/screens/home/weatherComp/weather_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _tokenChecked = false;

  @override
  void initState() {
    super.initState();
    _checkTokenAndFetchData();
  }

  Future<void> _checkTokenAndFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
      return;
    }

    try {
      final weather = await _weatherController.fetchWeather();
      final quote = await _quoteController.fetchQuote();

      if (!mounted) return;

      setState(() {
        _weatherData = weather;
        _quoteData = quote;
        _errorMessage = null;
        _isLoading = false;
        _tokenChecked = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to fetch data: $e';
        _isLoading = false;
        _tokenChecked = true;
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Logout',    style: TextStyle(color: Color(0xFF4A90E2)),
),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel',    style: TextStyle(color: Color(0xFF4A90E2)),
),
            ),
          TextButton(
  onPressed: () => Navigator.of(context).pop(true),
  child: const Text(
    'OK',
    style: TextStyle(color: Color(0xFF4A90E2)),
  ),
),

          ],
        );
      },
    );

    if (shouldLogout == true) {
      await logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_tokenChecked) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        centerTitle: false,
        title: Text(
          'mimAR.',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 36,
            color: const Color(0xFF4A90E2),
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.blue.shade200.withOpacity(0.7),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
       actions: [
  Padding(
    padding: const EdgeInsets.only(right: 20),
    child: Tooltip(
      message: 'Logout',
  child: SizedBox(
  height: 30,
  width: 100,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4A90E2),
      padding: EdgeInsets.zero,
      textStyle: const TextStyle(fontSize: 14),
    ),
    onPressed: _showLogoutDialog,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(width: 6),
        Icon(
          Icons.logout,
          color: Colors.white,
          size: 16,
        ),
      ],
    ),
  ),
),


    ),
  ),
],

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
                          description: _weatherData!['weather'][0]['description'],
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
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(
          Icons.auto_awesome,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AiChatScreen()),
          );
        },
      ),
    );
  }
}
