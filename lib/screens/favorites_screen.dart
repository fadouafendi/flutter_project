import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/spotify_provider.dart'; // Make sure this path is correct
import '../models/track.dart';             // Make sure this path is correct

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Watch the SpotifyProvider to react to changes in favorite status
    final provider = context.watch<SpotifyProvider>();

    // Filter the tracks to get only the favorites
    final favoriteTracks = provider.tracks.where((track) => track.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
        backgroundColor: Colors.black87, // Match your dark theme
      ),
      body: Container(
        color: Colors.black, // Dark background for the body
        child: favoriteTracks.isEmpty
            ? const Center(
                child: Text(
                  'No favorite movies yet!',
                  style: TextStyle(
                    color: Colors.white70, // Lighter text for dark background
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: favoriteTracks.length,
                itemBuilder: (context, i) {
                  final track = favoriteTracks[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 2,
                    color: Colors.grey[900], // Darker card background
                    child: ListTile(
                      leading: Hero(
                        tag: 'trackImage-${track.id}-favorite', // Unique tag for favorite screen hero animation
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(track.imageUrl,
                              width: 60, height: 60, fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(
                        track.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        track.artist,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          track.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: track.isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          // Toggling favorite directly from the favorites screen
                          provider.toggleFavorite(track);
                      
                        },
                      ),
                      onTap: () =>
                          Navigator.pushNamed(context, '/trackDetail', arguments: track),
                    ),
                  );
                },
              ),
      ),
    );
  }
}