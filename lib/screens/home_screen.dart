import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../services/prompt_generator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _random = Random();

  // This text is shown in the prompt box.
  String _prompt = 'Tap "Generate Prompt" to get started.';

  // Selected duration and currently visible countdown value.
  int _selectedDurationSeconds = 30;
  int _remainingSeconds = 30;

  // _timer drives the countdown; _isRunning helps disable UI when active.
  Timer? _timer;
  bool _isRunning = false;

  @override
  void dispose() {
    // Always stop timers when leaving the screen.
    _timer?.cancel();
    super.dispose();
  }

  void _selectDuration(int seconds) {
    if (_isRunning) return; // Keep it simple: don't change duration mid-timer.

    // setState tells Flutter to rebuild with updated values.
    setState(() {
      _selectedDurationSeconds = seconds;
      _remainingSeconds = seconds;
    });
  }

  void _generatePrompt() {
    setState(() {
      _prompt = generateRandomPrompt(_random);
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
        // Decrease once per second and stop exactly at zero.
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
    // Convert raw seconds into m:ss format (example: 65 -> 1:05).
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
        // onPressed: null disables the button in Flutter.
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
    // build can run often; it should describe UI from current state.
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
