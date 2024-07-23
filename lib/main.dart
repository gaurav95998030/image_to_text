import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_to_text/screens/home.dart';
import 'package:image_to_text/screens/splash_screen.dart';
import 'package:image_to_text/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp  extends StatelessWidget{

  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});




  @override
  Widget build(context){
    return AdaptiveTheme(
      light: Themes.light,
      dark: Themes.dark,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme,darkTheme)=> ProviderScope(
        child: MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          home: const SafeArea(
              top: true,
              child: SplashScreen()
          ),
          debugShowCheckedModeBanner: false,


        ),
      ),
    );
  }
}

