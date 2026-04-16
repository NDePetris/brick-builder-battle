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
  // Shared background image used across screens for a consistent look.
  static const _backgroundAsset = 'assets/images/cloudy_sky.png';

  // Reused shape language for cards and panels.
  static const _panelRadius = 24.0;

  // Prompt card border treatment. Kept layered, but softened a bit.
  static const _promptBorderWidth = 2.5;
  static const _promptOuterBorderWidth = 1.25;

  // Switch to smaller layout values on shorter displays.
  static const _compactHeightBreakpoint = 700.0;

  static const _compactPromptCardHeight = 170.0;
  static const _regularPromptCardHeight = 200.0;

  static const _compactGoButtonSize = 124.0;
  static const _regularGoButtonSize = 150.0;

  static const _compactHorizontalPadding = 20.0;
  static const _regularHorizontalPadding = 28.0;

  static const _compactPromptFontSize = 22.0;
  static const _regularPromptFontSize = 26.0;

  static const _compactTimerFontSize = 44.0;
  static const _regularTimerFontSize = 52.0;

  static const _compactButtonFontSize = 40.0;
  static const _regularButtonFontSize = 48.0;

  // Countdown timer instance.
  Timer? _timer;

  // True while countdown is actively running.
  bool _isRunning = false;

  // Current value shown in the timer panel.
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    // Show the full selected duration before the user taps GO.
    _remainingSeconds = widget.durationSeconds;
  }

  @override
  void dispose() {
    // Always cancel the timer when leaving the screen.
    _timer?.cancel();
    super.dispose();
  }

  /// Starts a fresh countdown from the original selected duration.
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

          // Delay the dialog until after the current frame finishes.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _showTimeUpDialog();
          });
        }
      });
    });
  }

  /// Stops the countdown and resets the display back to the original duration.
  void _stopAndResetCountdown() {
    _timer?.cancel();
    _timer = null;

    setState(() {
      _isRunning = false;
      _remainingSeconds = widget.durationSeconds;
    });
  }

  /// Shows a playful end-of-round dialog, then returns to the previous screen.
  void _showTimeUpDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white.withValues(alpha: 0.97),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_panelRadius),
            side: BorderSide(
              color: BrickColors.blue.withValues(alpha: 0.18),
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 14),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          actionsAlignment: MainAxisAlignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Small icon badge makes the moment feel more celebratory.
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: BrickColors.yellow.withValues(alpha: 0.24),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timer_off_rounded,
                  color: BrickColors.red,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Time's up!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: BrickColors.ink,
                      fontSize: 30,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Show off your build!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: BrickColors.ink.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                // Close the dialog first, then return to the previous screen.
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: BrickColors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 2,
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Converts seconds into m:ss format.
  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final mm = minutes.toString();
    final ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  /// Shared rounded panel styling for the prompt and timer surfaces.
  BoxDecoration _panelDecoration({
    double radius = _panelRadius,
    double backgroundOpacity = 0.84,
    Color shadowColor = BrickColors.blue,
    double shadowOpacity = 0.1,
    double blurRadius = 16,
    double borderWidth = 0,
    Color? borderColor,
    Gradient? gradient,
  }) {
    return BoxDecoration(
      color:
          gradient == null ? Colors.white.withValues(alpha: backgroundOpacity) : null,
      gradient: gradient,
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

  /// Shared cloud background with a light veil to keep text readable.
  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(_backgroundAsset, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: ColoredBox(
            color: Colors.white.withValues(alpha: 0.38),
          ),
        ),
      ],
    );
  }

  /// Large top card that displays the generated build prompt.
  Widget _buildPromptCard({
    required BuildContext context,
    required bool isCompactHeight,
    required double horizontalPadding,
    required double height,
    required double fontSize,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_panelRadius + 4),
          // Thin outer white line helps the card pop off the cloudy background.
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.94),
            width: _promptOuterBorderWidth,
          ),
          boxShadow: [
            // Gentle white glow keeps the prompt readable and playful.
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.35),
              blurRadius: 12,
              spreadRadius: 1,
            ),
            // Softer blue drop shadow keeps it consistent with the home screen.
            BoxShadow(
              color: BrickColors.blue.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          height: height,
          decoration: _panelDecoration(
            backgroundOpacity: 0.9,
            borderColor: BrickColors.blue.withValues(alpha: 0.7),
            borderWidth: _promptBorderWidth,
            shadowOpacity: 0.08,
            blurRadius: 14,
            // Soft white gradient adds depth without becoming too busy.
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.97),
                Colors.white.withValues(alpha: 0.9),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCompactHeight ? 18 : 24,
              vertical: isCompactHeight ? 18 : 24,
            ),
            child: Center(
              child: Text(
                widget.prompt,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      color: BrickColors.blue,
                      fontSize: fontSize,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Timer panel: intentionally simpler than the prompt card, but clearly related.
  Widget _buildTimerPanel({
    required BuildContext context,
    required bool isCompactHeight,
    required double fontSize,
    required double maxWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // Keep this panel wide enough to feel substantial, but not as wide as the prompt.
          maxWidth: maxWidth,
          minWidth: isCompactHeight ? 220 : 260,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_panelRadius + 2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.82),
              width: 1,
            ),
            boxShadow: [
              // Light highlight helps visually tie this panel to the prompt card.
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.22),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompactHeight ? 28 : 34,
              vertical: isCompactHeight ? 14 : 18,
            ),
            decoration: _panelDecoration(
              backgroundOpacity: 0.86,
              borderColor: BrickColors.blue.withValues(alpha: 0.22),
              borderWidth: 2,
              shadowOpacity: 0.08,
              blurRadius: 14,
            ),
            child: Text(
              _formatTime(_remainingSeconds),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    // Kept black per your request for strong readability.
                    color: Colors.black,
                    fontSize: fontSize,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  /// Circular GO / STOP button. Same behavior as before, but slightly softened visually.
  Widget _buildGoButton({
    required double size,
    required double fontSize,
  }) {
    // Keep green for GO and red for STOP, but soften the STOP red a touch
    // so it feels less like an error state.
    final buttonColor = _isRunning
        ? Color.lerp(BrickColors.red, Colors.white, 0.12)!
        : BrickColors.green;

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          // Small white highlight keeps the button feeling polished and tappable.
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.18),
            blurRadius: 8,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: buttonColor.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: FilledButton(
          onPressed: _isRunning ? _stopAndResetCountdown : _startCountdown,
          style: FilledButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
          ),
          child: Text(
            _isRunning ? 'STOP' : 'GO',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Slightly more playful than "Build" while keeping the same role.
        title: Text(
          'Build Challenge',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: BrickColors.blue,
              ),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Compact mode reduces element sizes on shorter screens.
                final isCompactHeight =
                    constraints.maxHeight < _compactHeightBreakpoint;

                final promptCardHeight = isCompactHeight
                    ? _compactPromptCardHeight
                    : _regularPromptCardHeight;
                final goButtonSize = isCompactHeight
                    ? _compactGoButtonSize
                    : _regularGoButtonSize;
                final horizontalPadding = isCompactHeight
                    ? _compactHorizontalPadding
                    : _regularHorizontalPadding;
                final promptFontSize = isCompactHeight
                    ? _compactPromptFontSize
                    : _regularPromptFontSize;
                final timerFontSize = isCompactHeight
                    ? _compactTimerFontSize
                    : _regularTimerFontSize;
                final buttonFontSize = isCompactHeight
                    ? _compactButtonFontSize
                    : _regularButtonFontSize;

                // Position major elements by rough vertical thirds.
                final promptCardTop = (constraints.maxHeight * 0.25) -
                    (isCompactHeight ? 120 : 150);
                final timerTop = (constraints.maxHeight * 0.5) -
                    (isCompactHeight ? 36 : 44);
                final goButtonTop =
                    (constraints.maxHeight * 0.75) - (goButtonSize / 2);

                // Timer stays wide, but intentionally narrower than the prompt card.
                final timerWidth =
                    constraints.maxWidth * (isCompactHeight ? 0.62 : 0.68);

                return Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: promptCardTop,
                      child: _buildPromptCard(
                        context: context,
                        isCompactHeight: isCompactHeight,
                        horizontalPadding: horizontalPadding,
                        height: promptCardHeight,
                        fontSize: promptFontSize,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: timerTop,
                      child: _buildTimerPanel(
                        context: context,
                        isCompactHeight: isCompactHeight,
                        fontSize: timerFontSize,
                        maxWidth: timerWidth,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: goButtonTop,
                      child: Center(
                        child: _buildGoButton(
                          size: goButtonSize,
                          fontSize: buttonFontSize,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}