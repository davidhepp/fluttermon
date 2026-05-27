import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fluttermon/app_routes.dart';
import 'package:fluttermon/models/app_settings.dart';
import 'package:fluttermon/models/pokemon.dart';
import 'package:fluttermon/models/pokemon_detail.dart';
import 'package:fluttermon/models/pokemon_page.dart';
import 'package:fluttermon/models/user_profile.dart';
import 'package:fluttermon/providers/collection_provider.dart';
import 'package:fluttermon/providers/navigation_provider.dart';
import 'package:fluttermon/providers/pokemon_detail_provider.dart';
import 'package:fluttermon/providers/pokemon_provider.dart';
import 'package:fluttermon/providers/profile_provider.dart';
import 'package:fluttermon/providers/settings_provider.dart';
import 'package:fluttermon/providers/team_provider.dart';
import 'package:fluttermon/screens/home_screen.dart';
import 'package:fluttermon/screens/pokemon_detail_screen.dart';
import 'package:fluttermon/screens/profile_screen.dart';
import 'package:fluttermon/screens/settings_screen.dart';
import 'package:fluttermon/services/collection_service.dart';
import 'package:fluttermon/services/pokemon_service.dart';
import 'package:fluttermon/services/profile_service.dart';
import 'package:fluttermon/services/settings_service.dart';
import 'package:fluttermon/services/team_service.dart';
import 'package:fluttermon/theme/app_theme.dart';

void main() {
  testWidgets('changes trainer name, collects a pokemon, and adds it to team', (
    tester,
  ) async {
    const bulbasaur = Pokemon(
      name: 'bulbasaur',
      url: 'https://pokeapi.co/api/v2/pokemon/1/',
    );
    final pokemonService = _FakePokemonService(bulbasaur);
    final collectionProvider = CollectionProvider(_FakeCollectionService());
    final teamProvider = TeamProvider(_FakeTeamService());
    final profileProvider = ProfileProvider(_FakeProfileService());
    final settingsProvider = SettingsProvider(_FakeSettingsService());
    final pokemonProvider = PokemonProvider(pokemonService);

    await pokemonProvider.fetchPokemons();
    await collectionProvider.fetchCollection();
    await teamProvider.fetchTeam();
    await profileProvider.fetchProfile();
    await settingsProvider.loadSettings();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: pokemonProvider),
          ChangeNotifierProvider.value(value: collectionProvider),
          ChangeNotifierProvider.value(value: teamProvider),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider.value(value: profileProvider),
          ChangeNotifierProvider.value(value: settingsProvider),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.home,
          routes: {
            AppRoutes.home: (_) => const HomeScreen(),
            AppRoutes.profile: (_) => const ProfileScreen(),
            AppRoutes.settings: (_) => const SettingsScreen(),
            AppRoutes.pokemonDetail: (_) => ChangeNotifierProvider(
              create: (_) => PokemonDetailProvider(pokemonService),
              child: const PokemonDetailScreen(),
            ),
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Misty');
    await tester.tap(find.byTooltip('Save trainer name'));
    await tester.pumpAndSettle();
    expect(find.text('Misty'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Misty'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulbasaur'));
    await tester.pumpAndSettle();

    expect(find.text('Add to collection'), findsOneWidget);
    await tester.ensureVisible(find.text('Add to collection'));
    await tester.tap(find.text('Add to collection'));
    await tester.pumpAndSettle();
    expect(collectionProvider.isCollected(bulbasaur), isTrue);
    expect(find.text('Remove from collection'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Team'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulbasaur').last);
    await tester.pumpAndSettle();

    expect(teamProvider.team.first?.name, 'bulbasaur');
    expect(find.text('Bulbasaur'), findsWidgets);
  });
}

class _FakePokemonService extends PokemonService {
  _FakePokemonService(this._pokemon);

  final Pokemon _pokemon;

  @override
  Future<PokemonPage> loadPokemonIndex() async {
    return PokemonPage(pokemons: [_pokemon], hasNextPage: false);
  }

  @override
  Future<PokemonDetail> fetchPokemonDetail(Pokemon pokemon) async {
    return const PokemonDetail(
      id: 1,
      name: 'bulbasaur',
      imageUrl: null,
      types: ['grass', 'poison'],
      stats: [
        PokemonStat(name: 'hp', baseStat: 45),
        PokemonStat(name: 'attack', baseStat: 49),
      ],
      description: 'A strange seed was planted on its back.',
      genus: 'Seed Pokemon',
    );
  }
}

class _FakeCollectionService extends CollectionService {
  List<Pokemon> _collection = [];

  @override
  Future<List<Pokemon>> fetchCollection() async {
    return _collection;
  }

  @override
  Future<List<Pokemon>> addPokemon(Pokemon pokemon) async {
    if (_collection.any(
      (collectedPokemon) => collectedPokemon.id == pokemon.id,
    )) {
      return _collection;
    }

    _collection = [..._collection, pokemon];
    return _collection;
  }

  @override
  Future<List<Pokemon>> removePokemon(Pokemon pokemon) async {
    _collection = _collection.where((collectedPokemon) {
      return collectedPokemon.id != pokemon.id;
    }).toList();
    return _collection;
  }
}

class _FakeTeamService extends TeamService {
  List<Pokemon?> _team = List<Pokemon?>.filled(TeamService.teamSize, null);

  @override
  Future<List<Pokemon?>> fetchTeam() async {
    return _team;
  }

  @override
  Future<List<Pokemon?>> saveTeam(List<Pokemon?> team) async {
    _team = team;
    return _team;
  }
}

class _FakeProfileService extends ProfileService {
  UserProfile _profile = const UserProfile(
    name: 'Trainer',
    subtitle: 'Ready to catch them all',
  );

  @override
  Future<UserProfile> fetchProfile() async {
    return _profile;
  }

  @override
  Future<UserProfile> saveName(String name) async {
    _profile = _profile.copyWith(name: name.trim());
    return _profile;
  }
}

class _FakeSettingsService extends SettingsService {
  AppSettings _settings = const AppSettings(themeMode: ThemeMode.light);

  @override
  Future<AppSettings> loadSettings() async {
    return _settings;
  }

  @override
  Future<AppSettings> saveThemeMode(ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    return _settings;
  }
}
