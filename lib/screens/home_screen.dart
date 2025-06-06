import 'package:flutter/material.dart';
import 'package:SpotyPoty/screens/favorites_screen.dart';

import '../widgets/app_drawer.dart';
import 'tracks_list_screen.dart';
import 'artists_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _screens = [TracksListScreen(), ArtistsListScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0
            ? 'Top Tracks'
            : _currentIndex == 1
                ? 'Top Artists'
                : 'Your Favorites'),
      ),
      drawer: AppDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: 'Tracks'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Artists'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
