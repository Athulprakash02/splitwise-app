import 'package:flutter/material.dart';

import 'constants.dart';

final theme = ThemeData(
    primaryColor: themeColor,
    primarySwatch: Colors.red,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        splashColor: cyanColor, backgroundColor: themeColor),
    appBarTheme: const AppBarTheme(backgroundColor: themeColor),
    // buttonTheme: ButtonThemeData(buttonColor: themeColor)
    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(themeColor))));
