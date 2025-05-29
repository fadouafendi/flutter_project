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
   
    }
    isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(Track track) {
    track.isFavorite = !track.isFavorite;
    notifyListeners(); 
  }


  void clearFavorites() {
    for (var track in tracks) {
      track.isFavorite = false; 
    }
    notifyListeners(); 
    debugPrint('All favorites cleared!');
  }
}
