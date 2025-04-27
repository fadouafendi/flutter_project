import 'package:flutter/material.dart';

import '../models/track.dart';

class TrackDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final track = ModalRoute.of(context)!.settings.arguments as Track;
    return Scaffold(
      appBar: AppBar(title: const Text('Track Details')),
      body: Center(
        // ← wrap in Center
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16), // ← only horizontal gutters
          child: Column(
            mainAxisSize: MainAxisSize.min, // ← shrink‐wrap height
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'trackImage-${track.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    track.imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                track.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Artist: ${track.artist}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (track.previewUrl != null)
                ElevatedButton(
                  onPressed: () {
                    // implémenter la lecture si souhaité
                  },
                  child: const Text('Play Preview'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
