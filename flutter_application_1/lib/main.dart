import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/profile_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env"); // Načtení .env souboru
    print("APP_ID: ${dotenv.env['APP_ID']}");
    print("API_KEY: ${dotenv.env['API_KEY']}");
  } catch (e) {
    print("Chyba při načítání .env: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(), // Výchozí obrazovka
    );
  }
}
