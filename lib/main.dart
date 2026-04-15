import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

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
      home: const BrickBuilderBattleScreen(),
    );
  }
}

class BrickBuilderBattleScreen extends StatefulWidget {
  const BrickBuilderBattleScreen({super.key});

  @override
  State<BrickBuilderBattleScreen> createState() =>
      _BrickBuilderBattleScreenState();
}

class _BrickBuilderBattleScreenState extends State<BrickBuilderBattleScreen> {
  final _random = Random();

  // In the future, these prompts could come from an API. For now, keep them local
  // and simple.
  final List<String> _objects = const ['dragon', 'castle', 'robot'];
  final List<String> _modifiers = const ['tiny', 'giant', 'upside-down'];
  final List<String> _styles = const ['futuristic', 'medieval', 'cartoon'];

  String _prompt = 'Tap "Generate Prompt" to get started.';

  int _selectedDurationSeconds = 30;
  int _remainingSeconds = 30;

  Timer? _timer;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectDuration(int seconds) {
    if (_isRunning) return; // Keep it simple: don't change duration mid-timer.

    setState(() {
      _selectedDurationSeconds = seconds;
      _remainingSeconds = seconds;
    });
  }

  void _generatePrompt() {
    final object = _objects[_random.nextInt(_objects.length)];
    final modifier = _modifiers[_random.nextInt(_modifiers.length)];
    final style = _styles[_random.nextInt(_styles.length)];

    setState(() {
      _prompt = 'Build a $modifier $style $object';
    });
  }

  void _startTimer() {
    if (_isRunning) return; // Prevent multiple timers running at once.

    _timer?.cancel(); // Safety: ensure any old timer is gone.

    setState(() {
      _isRunning = true;
      _remainingSeconds = _selectedDurationSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        _remainingSeconds--;

        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          _isRunning = false;
          _timer?.cancel();
          _timer = null;
        }
      });
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final mm = minutes.toString();
    final ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Widget _timerChoiceButton(String label, int seconds) {
    final isSelected = _selectedDurationSeconds == seconds;

    return Expanded(
      child: ElevatedButton(
        onPressed: _isRunning ? null : () => _selectDuration(seconds),
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
    final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Brick Builder Battle', style: titleStyle),
              const SizedBox(height: 16),

              Text(
                'Current prompt',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _prompt,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              const SizedBox(height: 16),
              Text(
                'Timer',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
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
                onPressed: _generatePrompt,
                child: const Text('Generate Prompt'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _isRunning ? null : _startTimer,
                child: Text(_isRunning ? 'Timer Running...' : 'Start Timer'),
              ),

              const SizedBox(height: 16),
              Text(
                'Remaining time',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              const Spacer(),
              Text(
                'Tip: Build as fast as you can, then snap a photo later (future feature).',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
