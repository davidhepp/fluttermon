import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final String imagePath;

  static const double expandedHeight = 180;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final appBarColors = ImageAppBarColors.of(context);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      expandedHeight: expandedHeight,
      elevation: 0,
      backgroundColor: appBarColors.background,
      surfaceTintColor: appBarColors.surfaceTint,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final minHeight = kToolbarHeight + topPadding;
          final availableHeight = expandedHeight + topPadding - minHeight;
          final expandedProgress =
              ((constraints.maxHeight - minHeight) / availableHeight).clamp(
                0.0,
                1.0,
              );
          final alignment = Alignment.lerp(
            Alignment.topCenter,
            Alignment.center,
            expandedProgress,
          )!;
          final textStyle = TextStyle.lerp(
            Theme.of(context).textTheme.titleLarge,
            Theme.of(context).textTheme.headlineMedium,
            expandedProgress,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              Container(color: appBarColors.imageOverlay),
              Padding(
                padding: EdgeInsets.only(top: topPadding + 10),
                child: Align(
                  alignment: alignment,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textStyle?.copyWith(
                      color: appBarColors.title,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
