import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/navigation_provider.dart';
import 'providers/pokemon_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/home_screen.dart';
import 'services/pokemon_service.dart';
import 'services/profile_service.dart';
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
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(ProfileService())..fetchProfile(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
