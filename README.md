# fluttermon

No description yet

## Structure

The folder structure of the app is as follows:

```text
lib/
  main.dart
  models/
  services/
  providers/
  screens/
  widgets/
```

## What References What

`main.dart`

- Imports `PokemonProvider`, `PokemonService`, and `PokemonListScreen`.
- Creates the `ChangeNotifierProvider`.
- Builds the `MaterialApp`.
- Starts the app on `PokemonListScreen`.

`models/pokemon.dart`

- Defines the `Pokemon` model.
- Converts one Pokemon JSON object into a Dart object with `Pokemon.fromJson`.
- Does not depend on other app files.

`services/pokemon_service.dart`

- Imports `http` for the API request.
- Imports `Pokemon` from `models/pokemon.dart`.
- Fetches data from `https://pokeapi.co/api/v2/pokemon?limit=10000`.
- Parses JSON and returns `List<Pokemon>`.
- Throws `PokemonServiceException` when the API response is not successful.

`providers/pokemon_provider.dart`

- Imports `Pokemon` from `models/pokemon.dart`.
- Imports `PokemonService` from `services/pokemon_service.dart`.
- Owns the app state for the Pokemon list:
- `pokemons`
- `isLoading`
- `errorMessage`
- Calls `PokemonService.fetchPokemons()`.
- Notifies the UI when loading, success, or error state changes.

`screens/pokemon_list_screen.dart`

- Imports `PokemonProvider`.
- Imports `PokemonList`.
- Reads state with `context.watch<PokemonProvider>()`.
- Shows:
- A loading spinner while data is loading.
- An error message and retry button if loading fails.
- An empty message if no Pokemon are returned.
- The `PokemonList` widget when Pokemon are available.

`widgets/pokemon_list.dart`

- Imports the `Pokemon` model.
- Receives `List<Pokemon>` from the screen.
- Builds the basic list UI.

## Data Flow

1. `main.dart` creates `PokemonProvider` and gives it a `PokemonService`.
2. `PokemonProvider.fetchPokemons()` runs when the provider is created.
3. `PokemonProvider` asks `PokemonService` to fetch Pokemon from the API.
4. `PokemonService` makes the HTTP request and converts JSON into `Pokemon` models.
5. `PokemonProvider` stores the result in `pokemons` and notifies listeners.
6. `PokemonListScreen` rebuilds because it watches `PokemonProvider`.
7. `PokemonListScreen` passes the Pokemon list to `PokemonList`.
8. `PokemonList` renders the names.

## State Handling

All asynchronous API loading is handled by `PokemonProvider`.

- Loading state: `isLoading == true`, shown as `CircularProgressIndicator`.
- Error state: `errorMessage != null`, shown with a retry button.
- Empty state: `pokemons.isEmpty`, shown as `No pokemons found`.
- Success state: `pokemons` contains data, shown in the list.
