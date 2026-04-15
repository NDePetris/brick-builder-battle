import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BrickBuilderBattleApp());
}

class BrickBuilderBattleApp extends StatelessWidget {
  const BrickBuilderBattleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brick Builder Battle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
