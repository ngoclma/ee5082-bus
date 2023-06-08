import 'package:flutter/material.dart';

class BusTheme {
  ThemeData themedata = ThemeData(
      primaryColor: Colors.yellow,
      fontFamily: 'Raleway',
      textTheme: TextTheme(
        displayLarge:
            const TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        displayMedium: const TextStyle(
            fontSize: 32.0, color: Colors.black87, fontWeight: FontWeight.bold),
        titleLarge: const TextStyle(fontSize: 32.0),
        titleMedium: const TextStyle(
          fontSize: 16.0,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
            fontSize: 24.0,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
            fontWeight: FontWeight.normal),
      ));
}
