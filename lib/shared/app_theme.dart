import 'package:flutter/material.dart';

class AppTheme {
  // ... (restante do arquivo)
static final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.deepPurple,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: Colors.deepOrangeAccent,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme( // <<< Adicionado 'const' aqui
    color: Colors.deepPurple,
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // ...
    ),
  ),
  textTheme: const TextTheme( // <<< Adicionado 'const' aqui
    headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16.0),
    bodyMedium: TextStyle(fontSize: 14.0),
  ),
  inputDecorationTheme: const InputDecorationTheme( // <<< Adicionado 'const' aqui
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    labelStyle: TextStyle(color: Colors.grey),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ),
);
  }
