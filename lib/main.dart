import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_routes.dart';
import 'providers/collection_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/pokemon_detail_provider.dart';
import 'providers/pokemon_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/team_provider.dart';
import 'screens/collection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pokemon_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'services/collection_service.dart';
import 'services/pokemon_service.dart';
import 'services/profile_service.dart';
import 'services/settings_service.dart';
import 'services/team_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PokemonProvider(PokemonService())..fetchPokemons(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              CollectionProvider(CollectionService())..fetchCollection(),
        ),
        ChangeNotifierProvider(
          create: (_) => TeamProvider(TeamService())..fetchTeam(),
        ),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(ProfileService())..fetchProfile(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(SettingsService())..loadSettings(),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settingsProvider.themeMode,
            initialRoute: AppRoutes.home,
            routes: {
              AppRoutes.home: (_) => const HomeScreen(),
              AppRoutes.collection: (_) => const CollectionScreen(),
              AppRoutes.pokemonDetail: (_) => ChangeNotifierProvider(
                create: (_) => PokemonDetailProvider(PokemonService()),
                child: const PokemonDetailScreen(),
              ),
              AppRoutes.profile: (_) => const ProfileScreen(),
              AppRoutes.settings: (_) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
