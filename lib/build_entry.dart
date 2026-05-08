/// A simple local model that represents the result of one build round.
class BuildEntry {
  BuildEntry({
    required this.id,
    required this.prompt,
    required this.imagePath,
    required this.createdAt,
    required this.durationSeconds,
  });

  /// Unique identifier for the build entry.
  final String id;

  /// The prompt that was used for this build.
  final String prompt;

  /// The local filesystem path to the selected image.
  final String imagePath;

  /// When the build entry was created.
  final DateTime createdAt;

  /// How many seconds the user had to build.
  final int durationSeconds;

  /// Creates a new BuildEntry with a generated local id.
  factory BuildEntry.create({
    required String prompt,
    required String imagePath,
    required int durationSeconds,
  }) {
    return BuildEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      prompt: prompt,
      imagePath: imagePath,
      createdAt: DateTime.now(),
      durationSeconds: durationSeconds,
    );
  }

  /// Human-friendly mm:ss display of durationSeconds.
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
