import 'package:bus_app_flutter/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bus_app_flutter/screens/map_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Map App',
      home:  LoginScreen() ,
      //home: MapScreen(),
    );
  }
}
