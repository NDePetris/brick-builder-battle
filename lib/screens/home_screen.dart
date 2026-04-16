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
  // Shared assets used by this screen.
  static const _backgroundAsset = 'assets/images/cloudy_sky.png';
  static const _logoAsset = 'assets/images/app_logo.png';

  final _random = Random();

  // Default round length is 30 seconds until the user picks another option.
  int _selectedDurationSeconds = 30;
  // Prevents rapid double-taps from pushing PromptScreen multiple times.
  bool _isNavigating = false;

  // Updates the selected timer chip.
  void _selectDuration(int seconds) {
    setState(() {
      _selectedDurationSeconds = seconds;
    });
  }

  // Generates a prompt and navigates to PromptScreen with current settings.
  Future<void> _generatePromptAndGo() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    final prompt = generateRandomPrompt(_random);

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => PromptScreen(
          prompt: prompt,
          durationSeconds: _selectedDurationSeconds,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      _isNavigating = false;
    });
  }

  // Reusable "card-like" decoration to keep panel styling consistent.
  BoxDecoration _panelDecoration({
    double radius = 24,
    double backgroundOpacity = 0.8,
    Color shadowColor = BrickColors.blue,
    double shadowOpacity = 0.1,
    double blurRadius = 16,
    double borderWidth = 0,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: backgroundOpacity),
      borderRadius: BorderRadius.circular(radius),
      border: borderColor == null
          ? null
          : Border.all(
              color: borderColor,
              width: borderWidth,
            ),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withValues(alpha: shadowOpacity),
          blurRadius: blurRadius,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // Cloudy sky background + light white overlay for text contrast.
  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(_backgroundAsset, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: ColoredBox(
            color: Colors.white.withValues(alpha: 0.35),
          ),
        ),
      ],
    );
  }

  // Large branded logo area at the top of the screen.
  Widget _buildLogoSection(double width) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 240,
          maxWidth: width * 0.88,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: BrickColors.blue.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Image.asset(
            _logoAsset,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // Instruction panel that introduces the next action to the player.
  Widget _buildInstructionCard(BuildContext context) {
    return DecoratedBox(
      decoration: _panelDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        child: Text(
          'Pick a timer, then generate your build challenge.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: BrickColors.ink.withValues(alpha: 0.8),
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  // Timer options grouped in one panel so choices feel related.
  Widget _buildTimerSelector(bool isCompactWidth) {
    return DecoratedBox(
      decoration: _panelDecoration(
        backgroundOpacity: 0.82,
        borderColor: BrickColors.blue.withValues(alpha: 0.22),
        borderWidth: 2,
        blurRadius: 14,
        shadowOpacity: 0.08,
      ),
      child: Padding(
        // Tighten horizontal padding on narrow phones to prevent crowding.
        padding: EdgeInsets.fromLTRB(
          isCompactWidth ? 8 : 12,
          16,
          isCompactWidth ? 8 : 12,
          16,
        ),
        child: Row(
          children: [
            _timerChoiceButton('30s', 30, BrickColors.blue),
            _timerChoiceButton('1m', 60, BrickColors.red),
            _timerChoiceButton('2m', 120, BrickColors.yellow),
          ],
        ),
      ),
    );
  }

  // Primary action button with playful depth (gradient + shadow).
  Widget _buildGenerateButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: BrickColors.green.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF36C85F),
            BrickColors.green,
          ],
        ),
      ),
      child: FilledButton(
        onPressed: _isNavigating ? null : _generatePromptAndGo,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          _isNavigating ? 'Loading...' : 'Generate Prompt',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // Individual timer choice button with clear selected/unselected states.
  Widget _timerChoiceButton(String label, int seconds, Color accent) {
    final isSelected = _selectedDurationSeconds == seconds;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          onPressed: () => _selectDuration(seconds),
          style: FilledButton.styleFrom(
            backgroundColor:
                isSelected ? accent : Colors.white.withValues(alpha: 0.72),
            foregroundColor: isSelected ? Colors.white : accent,
            elevation: isSelected ? 6 : 1,
            shadowColor: accent.withValues(alpha: 0.45),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: accent,
                width: isSelected ? 3 : 2.5,
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
    // Small-width adjustment helps timer buttons fit on compact devices.
    final isCompactWidth = width < 380;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brick Builder Battle'),
        backgroundColor: Colors.white.withValues(alpha: 0.88),
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLogoSection(width),
                  const SizedBox(height: 24),
                  _buildInstructionCard(context),
                  const SizedBox(height: 24),
                  _buildTimerSelector(isCompactWidth),
                  const SizedBox(height: 24),
                  _buildGenerateButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}