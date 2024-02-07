import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color.fromARGB(255, 113, 19, 129),
        onPrimary: Colors.purple,
        secondary: Color.fromARGB(255, 15, 87, 146),
        onSecondary: Colors.blue,
        error: Color.fromARGB(255, 146, 29, 21),
        onError: Color.fromARGB(255, 201, 24, 24),
        background: Colors.white,
        onBackground: Color.fromARGB(255, 95, 51, 51),
        surface: Colors.white,
        onSurface: Colors.black),
    appBarTheme: AppBarTheme(backgroundColor: Colors.purple));

ThemeData darkMode = ThemeData();
