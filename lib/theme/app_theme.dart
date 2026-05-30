import 'package:flutter/material.dart';

import 'app_colors.dart';

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
      seedColor: AppColors.yellow,
      brightness: Brightness.light,
      primary: AppColors.yellow,
      onPrimary: AppColors.navy,
      secondary: AppColors.navy,
      onSecondary: AppColors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightText,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightText,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightBackground,
      indicatorColor: AppColors.yellow,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    extensions: const [
      ImageAppBarColors(
        background: AppColors.transparent,
        surfaceTint: AppColors.transparent,
        imageOverlay: AppColors.lightHeaderOverlay,
        title: AppColors.white,
      ),
    ],
  );

  static final ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkBlue,
      brightness: Brightness.dark,
      primary: AppColors.darkBlue,
      onPrimary: AppColors.white,
      secondary: AppColors.white,
      onSecondary: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkText,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkText,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(color: AppColors.darkCardSurface),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      indicatorColor: AppColors.darkBlue,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    extensions: const [
      ImageAppBarColors(
        background: AppColors.transparent,
        surfaceTint: AppColors.transparent,
        imageOverlay: AppColors.darkHeaderOverlay,
        title: AppColors.white,
      ),
    ],
  );
}
