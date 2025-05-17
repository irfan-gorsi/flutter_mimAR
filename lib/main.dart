import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mimar/screens/home/home.dart';
import 'package:mimar/screens/login/login.dart';
import 'package:mimar/screens/signup/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await dotenv.load(fileName: "assets/.env");

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  // Initial permission and service check
  final bool locationEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission permission = await Geolocator.checkPermission();

  // If permission denied, request it
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever ||
      !locationEnabled ||
      permission == LocationPermission.denied) {
    runApp(const LocationRequiredApp());
    return;
  }

  runApp(ProviderScope(child: MyApp(initialRoute: token != null ? '/home' : '/signup')));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mimAR',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class LocationRequiredApp extends StatefulWidget {
  const LocationRequiredApp({super.key});

  @override
  State<LocationRequiredApp> createState() => _LocationRequiredAppState();
}

class _LocationRequiredAppState extends State<LocationRequiredApp> with WidgetsBindingObserver {
  bool _locationServiceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;
  bool _navigated = false; // Prevent multiple navigations

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLocationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationStatus();
    }
  }

  Future<void> _checkLocationStatus() async {
    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!locationEnabled) {
      setState(() {
        _locationServiceEnabled = false;
        _permission = permission;
      });
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    setState(() {
      _locationServiceEnabled = locationEnabled;
      _permission = permission;
    });

    if (!_navigated &&
        locationEnabled &&
        (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse)) {
      _navigated = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (!mounted) return;

      // Small delay to ensure UI settled before navigating
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProviderScope(child: MyApp(initialRoute: token != null ? '/home' : '/signup')),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String message;
    Widget button;

    if (!_locationServiceEnabled) {
      message = 'Location services are disabled. Please enable location services.';
      button = ElevatedButton(
        onPressed: () async {
          await Geolocator.openLocationSettings();
        },
        child: const Text('Enable Location Services'),
      );
    } else if (_permission == LocationPermission.deniedForever) {
      message = 'Location permission denied permanently. Please enable permission from app settings.';
      button = ElevatedButton(
        onPressed: () async {
          await Geolocator.openAppSettings();
        },
        child: const Text('Open App Settings'),
      );
    } else if (_permission == LocationPermission.denied) {
      message = 'Location permission is required to continue.';
      button = ElevatedButton(
        onPressed: () async {
          final requestedPermission = await Geolocator.requestPermission();
          setState(() {
            _permission = requestedPermission;
          });
          _checkLocationStatus();
        },
        child: const Text('Request Permission'),
      );
    } else {
      message = 'Checking location status...';
      button = const CircularProgressIndicator();
    }

    return MaterialApp(
      title: 'Location Required',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Enable Location')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 100, color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                button,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
