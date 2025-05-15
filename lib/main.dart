import 'package:flutter/material.dart';
import 'package:flutter/services.dart';            
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mimar/screens/home/home.dart';
import 'package:mimar/screens/login/login.dart';
import 'package:mimar/screens/signup/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await dotenv.load(fileName: "assets/.env");

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

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
