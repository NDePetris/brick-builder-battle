import 'dart:math';

import '../data/prompt_data.dart';

// Simple service for creating one random build prompt.
String generateRandomPrompt(Random random) {
  final object = promptObjects[random.nextInt(promptObjects.length)];
  final modifier = promptModifiers[random.nextInt(promptModifiers.length)];
  final style = promptStyles[random.nextInt(promptStyles.length)];

  return 'Build a $modifier $style $object';
}
