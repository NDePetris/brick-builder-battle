import 'dart:async';

import 'package:flutter/material.dart';

import '../brick_colors.dart';

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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _showTimeUpDialog();
          });
        }
      });
    });
  }

  void _stopAndResetCountdown() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
      _remainingSeconds = widget.durationSeconds;
    });
  }

  void _showTimeUpDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.timer_off_rounded, color: BrickColors.red, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Time's up!",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: BrickColors.ink,
                      ),
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: BrickColors.blue,
                foregroundColor: Colors.white,
              ),
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
      body: Container(
        width: double.infinity,
        color: const Color(0xFFE5E5E7),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const promptCardHeight = 200.0;
              final promptCardTop = (constraints.maxHeight * 0.25) - 150;
              const goButtonSize = 150.0;
              return Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: promptCardTop,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Container(
                        height: promptCardHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: BrickColors.blue,
                            width: 4,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                          child: Center(
                            child: Text(
                              widget.prompt,
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                                color: BrickColors.blue,
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _formatTime(_remainingSeconds),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            color: Colors.black,
                            fontSize: 52,
                          ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: (constraints.maxHeight * 0.75) - (goButtonSize / 2),
                    child: Center(
                      child: SizedBox(
                        width: goButtonSize,
                        height: goButtonSize,
                        child: FilledButton(
                          onPressed:
                              _isRunning ? _stopAndResetCountdown : _startCountdown,
                          style: FilledButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor:
                                _isRunning
                                    ? const Color(0xFFE31B23)
                                    : const Color(0xFF22B14C),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            _isRunning ? 'STOP' : 'GO',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
