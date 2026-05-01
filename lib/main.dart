import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/pokemon_provider.dart';
import 'screens/pokemon_list_screen.dart';
import 'services/pokemon_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PokemonProvider(PokemonService())..fetchPokemons(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PokemonListScreen(),
      ),
    );
  }
}
