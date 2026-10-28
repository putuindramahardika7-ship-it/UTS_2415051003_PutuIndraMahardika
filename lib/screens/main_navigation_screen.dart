import 'package:flutter/material.dart';
import '../widgets/responsive_builder.dart';
import 'home_screen.dart';
import 'kos_catalog_screen.dart';
import 'saved_kos_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: (index) => setState(() => _selectedIndex = index)),
      const KosCatalogScreen(),
      const SavedKosScreen(),
      const ProfileScreen(),
    ];

    return ResponsiveBuilder(
      // Layout Compact (Smartphone)
      compact: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Katalog'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Favorit'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
      // Layout Wide (Tablet/Desktop)
      wide: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.search), label: Text('Katalog')),
                NavigationRailDestination(icon: Icon(Icons.bookmark), label: Text('Favorit')),
                NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profil')),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: IndexedStack(index: _selectedIndex, children: screens)),
          ],
        ),
      ),
    );
  }
}
