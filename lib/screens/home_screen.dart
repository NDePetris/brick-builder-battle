import 'dart:math';

import 'package:flutter/material.dart';

import '../brick_colors.dart';
import '../services/prompt_generator.dart';
import 'prompt_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _random = Random();

  int _selectedDurationSeconds = 30;

  void _selectDuration(int seconds) {
    setState(() {
      _selectedDurationSeconds = seconds;
    });
  }

  void _generatePromptAndGo() {
    final prompt = generateRandomPrompt(_random);

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => PromptScreen(
          prompt: prompt,
          durationSeconds: _selectedDurationSeconds,
        ),
      ),
    );
  }

  /// Each timer maps to a logo color so choices feel distinct and playful.
  Widget _timerChoiceButton(String label, int seconds, Color accent) {
    final isSelected = _selectedDurationSeconds == seconds;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          onPressed: () => _selectDuration(seconds),
          style: FilledButton.styleFrom(
            backgroundColor:
                isSelected ? accent : accent.withValues(alpha: 0.12),
            foregroundColor: isSelected ? Colors.white : accent,
            elevation: isSelected ? 4 : 0,
            shadowColor: accent.withValues(alpha: 0.45),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: accent,
                width: isSelected ? 3 : 2,
              ),
            ),
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brick Builder Battle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 240,
                    maxWidth: width * 0.88,
                  ),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Pick a timer, then generate your build challenge.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: BrickColors.ink.withValues(alpha: 0.75),
                      height: 1.35,
                    ),
              ),
              const SizedBox(height: 20),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: BrickColors.blue.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: BrickColors.blue.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                  child: Row(
                    children: [
                      _timerChoiceButton('30s', 30, BrickColors.blue),
                      _timerChoiceButton('1m', 60, BrickColors.blue),
                      _timerChoiceButton('2m', 120, BrickColors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _generatePromptAndGo,
                style: FilledButton.styleFrom(
                  backgroundColor: BrickColors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Generate Prompt'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
