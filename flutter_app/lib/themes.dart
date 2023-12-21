import 'package:flutter/material.dart';

//COLORS
const Color primaryColor = Color.fromARGB(255, 10, 175, 170); //primary button and appBar
const Color secondaryColor = Color.fromARGB(255, 60, 175, 170); //background such as scaffold and body
const Color subtleColor = Color.fromARGB(255, 94, 113, 152); //other buttons

const Color informationColor = Colors.blue;
const Color successColor = Colors.green;
const Color dangerColor = Colors.red;
const Color cautionColor = Colors.yellow;

const Color darkColor = Color.fromARGB(200, 0, 0, 0);
const Color lightColor = Color.fromARGB(230, 255, 255, 255);


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: primaryColor,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16, color: primaryColor),
    bodySmall: TextStyle(fontSize: 15, color: subtleColor),
    displayLarge: TextStyle(fontSize: 48, color: darkColor),
  ),
  appBarTheme: const AppBarTheme(
    color: primaryColor,
    iconTheme: IconThemeData(color: darkColor),
  ),
  cardTheme: const CardTheme(
    color: lightColor,
    shadowColor: darkColor,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: secondaryColor,
    primary: primaryColor,
    error : dangerColor,
    brightness: Brightness.light,
    background: lightColor,
  ),
);