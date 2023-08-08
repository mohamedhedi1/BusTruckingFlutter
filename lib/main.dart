import 'package:flutter/material.dart';
import 'package:bus_app_flutter/screens/map_screen.dart'; // Importez la classe MapScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Map App',
      home: MapScreen(), // Utilisez la classe MapScreen comme page d'accueil
    );
  }
}