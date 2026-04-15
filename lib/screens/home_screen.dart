import 'dart:math';

import 'package:flutter/material.dart';

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

  Widget _timerChoiceButton(String label, int seconds) {
    final isSelected = _selectedDurationSeconds == seconds;

    return Expanded(
      child: ElevatedButton(
        onPressed: () => _selectDuration(seconds),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : null,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : null,
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _timerChoiceButton('30s', 30),
                  const SizedBox(width: 8),
                  _timerChoiceButton('1m', 60),
                  const SizedBox(width: 8),
                  _timerChoiceButton('2m', 120),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _generatePromptAndGo,
                child: const Text('Generate Prompt'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
