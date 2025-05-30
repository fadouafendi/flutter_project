import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/spotify_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SpotifyProvider>(
      builder: (context, provider, child) {
        final favoriteTracks =
            provider.tracks.where((track) => track.isFavorite).toList();

        return Container(
          color: Colors.black,
          child: favoriteTracks.isEmpty
              ? const Center(
                  child: Text(
                    'No favorite tracks yet!',
                    style: TextStyle(
                      color: Colors.white70,
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
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: Hero(
                          tag:
                              'trackImage-${track.id}-favorite',
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
                            track.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: track.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            provider.toggleFavorite(track);
                          },
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, '/trackDetail',
                            arguments: track),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
