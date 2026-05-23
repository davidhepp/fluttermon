import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            if (profileProvider.isLoading) {
              return const CircularProgressIndicator();
            }

            if (profileProvider.errorMessage != null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(profileProvider.errorMessage!),
                  TextButton(
                    onPressed: profileProvider.fetchProfile,
                    child: const Text('Retry'),
                  ),
                ],
              );
            }

            final profile = profileProvider.profile;
            if (profile == null) {
              return const Text('No profile found');
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(profile.subtitle),
              ],
            );
          },
        ),
      ),
    );
  }
}
