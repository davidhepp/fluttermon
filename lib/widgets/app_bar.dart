import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';
import '../theme/app_theme.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool showProfileButton;

  static const double expandedHeight = 180;

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
      leading: showProfileButton
          ? Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _AppBarCircleButton(
                icon: Icons.person,
                tooltip: 'Profile',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            )
          : null,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
