import 'package:flutter/material.dart';

import '../models/artist.dart';

class ArtistDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final artist = ModalRoute.of(context)!.settings.arguments as Artist;
    return Scaffold(
      appBar: AppBar(title: const Text('Artist Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: 'artistImage-${artist.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(artist.imageUrl,
                    width: 200, height: 200, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Text(artist.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (artist.genres.isNotEmpty)
              Text('Genres: ${artist.genres.join(', ')}',
                  textAlign: TextAlign.center),
            if (artist.popularity != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Popularity: ${artist.popularity}'),
              ),
          ],
        ),
      ),
    );
  }
}
