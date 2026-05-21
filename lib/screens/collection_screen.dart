import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: 'Collection',
            imagePath: 'assets/images/appbar/appbar1.png',
            showProfileButton: true,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('Your collection is empty')),
          ),
        ],
      ),
    );
  }
}
