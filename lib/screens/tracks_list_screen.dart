import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/spotify_provider.dart';

class TracksListScreen extends StatefulWidget {
  @override
  _TracksListScreenState createState() => _TracksListScreenState();
}

class _TracksListScreenState extends State<TracksListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final spotifyProvider = context.read<SpotifyProvider>();

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
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    track.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: track.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    provider.toggleFavorite(track); // Toggle favorite status
                  },
                ),
                const SizedBox(width: 8),
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
