import 'package:flutter/material.dart';

///------------------------------------------------------------------------///
/// Custom colors
///------------------------------------------------------------------------///
const Color primaryColor = Colors.brown;
const Color secondaryColor = Color.fromARGB(255,222,184,135);
const Color subtleColor = Color.fromARGB(255, 255, 228, 196);

const Color informationColor = Colors.blue;
const Color successColor = Colors.green;
const Color dangerColor = Colors.red;
const Color cautionColor = Colors.yellow;
const Color disabledColor = Colors.grey;

const Color darkColor = Color.fromARGB(200, 0, 0, 0);
const Color lightColor = Color.fromARGB(255, 250, 235, 215);


///------------------------------------------------------------------------///
/// App Theme 
/// themes for specific widgets and in general
///------------------------------------------------------------------------///

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: primaryColor,

  //Text
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16, color: primaryColor),
    bodySmall: TextStyle(fontSize: 15, color: secondaryColor),
    displayLarge: TextStyle(fontSize: 48, color: darkColor),
  ),

  //Button
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColor,
      textStyle: const TextStyle(color: primaryColor),
    ),
  ),

  //NavigationBar
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: subtleColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: secondaryColor,
  ),

  //AppBar
  appBarTheme: const AppBarTheme(
    color: primaryColor,
    iconTheme: IconThemeData(color: darkColor),
  ),

  //Card
  cardTheme: const CardTheme(
    color: lightColor,
    shadowColor: darkColor,
  ),

  //Color Scheme
  colorScheme: ColorScheme.fromSeed(
    seedColor: secondaryColor,
    primary: primaryColor,
    error : dangerColor,
    brightness: Brightness.light,
    background: lightColor,
  ),
);