import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/spotify_provider.dart';
import '../models/track.dart';

class TracksListScreen extends StatefulWidget {
  @override
  _TracksListScreenState createState() => _TracksListScreenState();
}

class _TracksListScreenState extends State<TracksListScreen> {
@override
  void initState() {
    super.initState();
    // Use WidgetsBinding.instance.addPostFrameCallback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final spotifyProvider = context.read<SpotifyProvider>();
      // Only load data if it hasn't been loaded already
      if (spotifyProvider.tracks.isEmpty && !spotifyProvider.isLoading) {
        spotifyProvider.loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SpotifyProvider>();
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: provider.tracks.length,
      itemBuilder: (context, i) {
        final track = provider.tracks[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 2,
          child: ListTile(
            leading: Row( // Use a Row to place multiple widgets in leading
              mainAxisSize: MainAxisSize.min, // Essential to constrain the row's width
              children: [
                IconButton(
                  icon: Icon(
                    track.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: track.isFavorite ? Colors.red : Colors.grey, // Red for favorited, grey for not
                  ),
                  onPressed: () {
                    provider.toggleFavorite(track); // Toggle favorite status
                  },
                ),
                const SizedBox(width: 8), // Add some spacing between icon and image
                Hero(
                  tag: 'trackImage-${track.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(track.imageUrl,
                        width: 60, height: 60, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
            title: Text(track.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(track.artist),
            onTap: () =>
                Navigator.pushNamed(context, '/trackDetail', arguments: track),
          ),
        );
      },
    );
  }
}