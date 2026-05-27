import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool showProfileButton;

  static const double expandedHeight = 200;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    required this.imagePath,
    this.showProfileButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final appBarColors = ImageAppBarColors.of(context);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      actions: [
        if (showProfileButton)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _AppBarCircleButton(
              icon: Icons.person,
              tooltip: 'Profile',
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.profile);
              },
            ),
          ),
      ],
      pinned: true,
      expandedHeight: expandedHeight,
      elevation: 0,
      backgroundColor: appBarColors.background,
      surfaceTintColor: appBarColors.surfaceTint,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // the app bar can only shrink down to the toolbar plus the safe area
          final minHeight = kToolbarHeight + topPadding;
          final availableHeight = expandedHeight + topPadding - minHeight;

          // 0 means fully collapsed, 1 means fully expanded
          final expandedProgress =
              ((constraints.maxHeight - minHeight) / availableHeight).clamp(
                0.0,
                1.0,
              );

          // easing the progress to make the title movement feel smoother
          final easedProgress = Curves.easeInOutCubic.transform(
            expandedProgress,
          );

          // moving and resizing the title between the collapsed and expanded states
          final alignment = Alignment.lerp(
            Alignment.topCenter,
            Alignment.center,
            easedProgress,
          )!;
          final textStyle = TextStyle.lerp(
            Theme.of(context).textTheme.titleLarge,
            Theme.of(context).textTheme.headlineMedium,
            easedProgress,
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

class _AppBarCircleButton extends StatelessWidget {
  const _AppBarCircleButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.white),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
