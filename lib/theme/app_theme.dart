import 'package:flutter/material.dart';

@immutable
class ImageAppBarColors extends ThemeExtension<ImageAppBarColors> {
  final Color background;
  final Color surfaceTint;
  final Color imageOverlay;
  final Color title;

  const ImageAppBarColors({
    required this.background,
    required this.surfaceTint,
    required this.imageOverlay,
    required this.title,
  });

  static ImageAppBarColors of(BuildContext context) {
    return Theme.of(context).extension<ImageAppBarColors>()!;
  }

  @override
  ImageAppBarColors copyWith({
    Color? background,
    Color? surfaceTint,
    Color? imageOverlay,
    Color? title,
  }) {
    return ImageAppBarColors(
      background: background ?? this.background,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      imageOverlay: imageOverlay ?? this.imageOverlay,
      title: title ?? this.title,
    );
  }

  @override
  ImageAppBarColors lerp(ThemeExtension<ImageAppBarColors>? other, double t) {
    if (other is! ImageAppBarColors) {
      return this;
    }

    return ImageAppBarColors(
      background: Color.lerp(background, other.background, t)!,
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t)!,
      imageOverlay: Color.lerp(imageOverlay, other.imageOverlay, t)!,
      title: Color.lerp(title, other.title, t)!,
    );
  }
}

class AppTheme {
  static final ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE3350D),
      brightness: Brightness.light,
    ),
    extensions: const [
      ImageAppBarColors(
        background: Colors.transparent,
        surfaceTint: Colors.transparent,
        imageOverlay: Color(0x33000000),
        title: Colors.white,
      ),
    ],
  );

  static final ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE3350D),
      brightness: Brightness.dark,
    ),
    extensions: const [
      ImageAppBarColors(
        background: Colors.transparent,
        surfaceTint: Colors.transparent,
        imageOverlay: Color(0x73000000),
        title: Colors.white,
      ),
    ],
  );
}
