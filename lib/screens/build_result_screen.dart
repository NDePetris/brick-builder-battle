import 'dart:io';

import 'package:flutter/material.dart';

import '../brick_colors.dart';
import '../build_entry.dart';

/// Shows the completed build result after the user selects a photo.
class BuildResultScreen extends StatelessWidget {
  const BuildResultScreen({
    super.key,
    required this.entry,
  });

  final BuildEntry entry;

  /// Shared background asset used across the app.
  static const _backgroundAsset = 'assets/images/cloudy_sky.png';

  /// Consistent rounded panel radius.
  static const _panelRadius = 24.0;

  /// Builds the same soft card styling used elsewhere.
  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.84),
      borderRadius: BorderRadius.circular(_panelRadius),
      boxShadow: [
        BoxShadow(
          color: BrickColors.blue.withValues(alpha: 0.12),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Cloud background with a light overlay for readability.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Ready to share?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: BrickColors.ink,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Review your build and play again when you’re ready.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: BrickColors.ink.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: DecoratedBox(
                      decoration: _panelDecoration(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_panelRadius),
                        child: Image.file(
                          File(entry.imagePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  DecoratedBox(
                    decoration: _panelDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Prompt',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: BrickColors.ink.withValues(alpha: 0.68),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            entry.prompt,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: BrickColors.ink,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(
                                Icons.timer_rounded,
                                color: BrickColors.blue,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Time: ${entry.formattedDuration}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: BrickColors.ink.withValues(alpha: 0.78),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: BrickColors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'Play Again',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
