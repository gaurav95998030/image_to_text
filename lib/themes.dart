


import 'package:flutter/material.dart';

class Themes {

  static final light=ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: Colors.blue,
    fontFamily: 'MonaSans',

    drawerTheme: DrawerThemeData(

      backgroundColor: Colors.white
    )
  );
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.pink,
    fontFamily: 'MonaSans'
  );
}