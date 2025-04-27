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
    // charge les données après build
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
      itemCount: provider.tracks.length,
      itemBuilder: (context, i) {
        final track = provider.tracks[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 2,
          child: ListTile(
            leading: Hero(
              tag: 'trackImage-${track.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(track.imageUrl,
                    width: 60, height: 60, fit: BoxFit.cover),
              ),
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
