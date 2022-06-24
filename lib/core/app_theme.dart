import 'package:flutter/material.dart';

class AppTheme {
  static get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(),
        appBarTheme: const AppBarTheme(),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(),
      );

  static get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.greenAccent,
        iconTheme: const IconThemeData(color: Colors.black),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.black,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF444141)),
        scaffoldBackgroundColor: Colors.grey.shade900,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      );

  static void setStatusBarAndNavigationBarColor(ThemeMode themeMode) {}
}

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  getThemeMode() => _themeMode;

  setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
