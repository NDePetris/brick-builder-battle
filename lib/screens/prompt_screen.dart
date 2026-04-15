import 'dart:async';

import 'package:flutter/material.dart';

/// Shows the generated prompt and runs the countdown after the user taps Go.
class PromptScreen extends StatefulWidget {
  const PromptScreen({
    super.key,
    required this.prompt,
    required this.durationSeconds,
  });

  final String prompt;
  final int durationSeconds;

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  Timer? _timer;
  bool _isRunning = false;

  /// Countdown value shown on screen (starts at full duration before Go).
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (_isRunning) return;

    _timer?.cancel();

    setState(() {
      _isRunning = true;
      _remainingSeconds = widget.durationSeconds;
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
          // Show dialog after this frame so we are not inside setState's build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _showTimeUpDialog();
          });
        }
      });
    });
  }

  void _showTimeUpDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          content: const Text("Time's up!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final mm = minutes.toString();
    final ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    widget.prompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              Text(
                _formatTime(_remainingSeconds),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isRunning ? null : _startCountdown,
                  child: Text(_isRunning ? 'Running...' : 'Go'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
