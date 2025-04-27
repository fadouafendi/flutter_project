import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/spotify_provider.dart';

class ArtistsListScreen extends StatefulWidget {
  @override
  _ArtistsListScreenState createState() => _ArtistsListScreenState();
}

class _ArtistsListScreenState extends State<ArtistsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpotifyProvider>().loadData();
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
      itemCount: provider.artists.length,
      itemBuilder: (context, i) {
        final artist = provider.artists[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 2,
          child: ListTile(
            leading: Hero(
              tag: 'artistImage-${artist.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(artist.imageUrl,
                    width: 60, height: 60, fit: BoxFit.cover),
              ),
            ),
            title: Text(artist.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: artist.genres.isNotEmpty
                ? Text(artist.genres.take(2).join(', '))
                : null,
            onTap: () => Navigator.pushNamed(context, '/artistDetail',
                arguments: artist),
          ),
        );
      },
    );
  }
}
