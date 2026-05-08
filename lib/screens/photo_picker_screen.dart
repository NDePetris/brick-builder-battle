import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../brick_colors.dart';
import '../build_entry.dart';
import 'build_result_screen.dart';

/// Allows the user to select a photo from their device gallery
/// and confirm it before proceeding.
class PhotoPickerScreen extends StatefulWidget {
  const PhotoPickerScreen({
    super.key,
    required this.prompt,
    required this.durationSeconds,
  });

  /// The build prompt shown during the countdown.
  final String prompt;

  /// The countdown duration (in seconds) that was used.
  final int durationSeconds;

  @override
  State<PhotoPickerScreen> createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
  // Shared background image used across screens for a consistent look.
  static const _backgroundAsset = 'assets/images/cloudy_sky.png';

  // Reused shape language for cards and panels.
  static const _panelRadius = 24.0;

  // Switch to smaller layout values on shorter displays.
  static const _compactHeightBreakpoint = 700.0;

  static const _compactHorizontalPadding = 20.0;
  static const _regularHorizontalPadding = 28.0;

  static const _compactButtonFontSize = 16.0;
  static const _regularButtonFontSize = 18.0;

  // Stores the currently selected image file, or null if none is selected.
  XFile? _selectedImage;

  /// Opens the device gallery and lets the user pick an image.
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    try {
      // Open the gallery and allow only image selection.
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      // Show error message if something goes wrong during selection.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: BrickColors.red,
        ),
      );
    }
  }

  /// Called when the user taps the Continue button.
  /// Creates a local BuildEntry and opens the result screen.
  void _handleContinue() {
    if (_selectedImage == null) return;

    final buildEntry = BuildEntry.create(
      prompt: widget.prompt,
      imagePath: _selectedImage!.path,
      durationSeconds: widget.durationSeconds,
    );

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => BuildResultScreen(entry: buildEntry),
      ),
    );
  }

  /// Shared rounded panel styling for consistent card appearance.
  BoxDecoration _panelDecoration({
    double radius = _panelRadius,
    double backgroundOpacity = 0.84,
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

  /// Shared cloud background with a light veil to keep content readable.
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

  /// Builds the button that either prompts to pick an image or confirms the selection.
  Widget _buildPickButton({required bool isCompactHeight}) {
    final fontSize = isCompactHeight ? _compactButtonFontSize : _regularButtonFontSize;

    if (_selectedImage == null) {
      // Before an image is selected, show the pick button.
      return FilledButton.icon(
        onPressed: _pickImageFromGallery,
        icon: const Icon(Icons.photo_library_rounded),
        label: const Text('Pick Photo'),
        style: FilledButton.styleFrom(
          backgroundColor: BrickColors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 2,
        ),
      );
    }

    // After an image is selected, allow picking a different one or confirming.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Small button to go back and pick a different image.
        OutlinedButton.icon(
          onPressed: _pickImageFromGallery,
          icon: const Icon(Icons.photo_library_rounded),
          label: const Text('Change'),
          style: OutlinedButton.styleFrom(
            foregroundColor: BrickColors.blue,
            side: BorderSide(
              color: BrickColors.blue.withValues(alpha: 0.5),
              width: 2,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Primary button to confirm and continue.
        FilledButton(
          onPressed: _handleContinue,
          style: FilledButton.styleFrom(
            backgroundColor: BrickColors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 2,
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isCompactHeight = mediaQuery.size.height < _compactHeightBreakpoint;
    final horizontalPadding =
        isCompactHeight ? _compactHorizontalPadding : _regularHorizontalPadding;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: BrickColors.ink,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Cloudy sky background
          _buildBackground(),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      'Show Your Build!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: BrickColors.ink,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      'Pick a photo from your gallery',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: BrickColors.ink.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 24),
                    // Image preview area or placeholder
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DecoratedBox(
                        decoration: _panelDecoration(),
                        child: _selectedImage == null
                            ? // Placeholder when no image is selected
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(_panelRadius),
                                color: BrickColors.blue.withValues(alpha: 0.06),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 64,
                                      color: BrickColors.blue.withValues(alpha: 0.4),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No image selected yet',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: BrickColors.blue.withValues(alpha: 0.5),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : // Show the selected image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(_panelRadius),
                              child: Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,
                                height: 300,
                                width: double.infinity,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Pick/Change/Continue buttons
                    _buildPickButton(isCompactHeight: isCompactHeight),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
