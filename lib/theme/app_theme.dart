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
      seedColor: const Color(0xFFFFCB05),
      brightness: Brightness.light,
      primary: const Color(0xFFFFCB05),
      onPrimary: const Color(0xFF0B1F3A),
      secondary: const Color(0xFF0B1F3A),
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF0B1F3A),
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0B1F3A),
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFFFCB05),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
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
      seedColor: const Color(0xFF0D47A1),
      brightness: Brightness.dark,
      primary: const Color(0xFF0D47A1),
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: const Color(0xFF06111F),
      surface: const Color(0xFF050505),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.black,
      indicatorColor: const Color(0xFF0D47A1),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
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
