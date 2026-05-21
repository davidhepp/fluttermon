import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../widgets/page_indicator.dart';
import 'collection_screen.dart';
import 'pokemon_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectPage(int page) {
    context.read<NavigationProvider>().setCurrentPage(page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = context.watch<NavigationProvider>().currentPage;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: context.read<NavigationProvider>().setCurrentPage,
            children: const [PokemonListScreen(), CollectionScreen()],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 88 + MediaQuery.paddingOf(context).bottom,
            child: PageIndicator(currentPage: currentPage, pageCount: 2),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPage,
        onDestinationSelected: _selectPage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.catching_pokemon_outlined),
            selectedIcon: Icon(Icons.catching_pokemon),
            label: 'Main',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark_outlined),
            selectedIcon: Icon(Icons.collections_bookmark),
            label: 'Collection',
          ),
        ],
      ),
    );
  }
}
