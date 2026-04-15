import 'package:flutter/material.dart';
import 'brick_colors.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BrickBuilderBattleApp());
}

class BrickBuilderBattleApp extends StatelessWidget {
  const BrickBuilderBattleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.light(
      primary: BrickColors.blue,
      onPrimary: Colors.white,
      secondary: BrickColors.yellow,
      onSecondary: BrickColors.ink,
      tertiary: BrickColors.red,
      onTertiary: Colors.white,
      surface: BrickColors.surfaceTint,
      onSurface: BrickColors.ink,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brick Builder Battle',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: BrickColors.surfaceTint,
        appBarTheme: const AppBarTheme(
          backgroundColor: BrickColors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: BrickColors.ink,
              displayColor: BrickColors.ink,
            ),
      ),
      home: const HomeScreen(),
    );
  }
}
