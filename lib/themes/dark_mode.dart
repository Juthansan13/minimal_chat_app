import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(

    primary: Colors.grey.shade600,
    secondary: const Color.fromARGB(255, 56, 56, 56),
    surface: Colors.grey.shade900,
    onSurface: Colors.white,
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0.0,
  ),
);