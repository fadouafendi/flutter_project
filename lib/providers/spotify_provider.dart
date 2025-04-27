import 'package:flutter/material.dart';

import '../services/spotify_service.dart';
import '../models/track.dart';
import '../models/artist.dart';

class SpotifyProvider extends ChangeNotifier {
  final SpotifyService _service = SpotifyService();
  List<Track> tracks = [];
  List<Artist> artists = [];
  bool isLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();
    try {
      final fetchedTracks = await _service.getTopTracks();
      final fetchedArtists = await _service.getTopArtists();
      tracks = fetchedTracks;
      artists = fetchedArtists;
    } catch (_) {
      // Vous pouvez gérer l'erreur ici si besoin
    }
    isLoading = false;
    notifyListeners();
  }
}
