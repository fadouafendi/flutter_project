import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'services/spotify_service.dart';
import 'models/artist.dart';
import 'models/track.dart';
import 'widgets/artist_card.dart';
import 'widgets/track_card.dart';
import 'matchingPage.dart';
import 'services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SpotifyService _spotifyService = SpotifyService();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final AuthService _authService = AuthService();

  List<Track> _topTracks = [];
  List<Artist> _topArtists = [];
  List<String> _favoriteTracks = [];
  List<String> _favoriteArtists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
    _loadUserFavorites();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tracks = await _spotifyService.getTopTracks();
      final artists = await _spotifyService.getTopArtists();

      if (tracks.isEmpty || artists.isEmpty) {
        throw Exception('Failed to load data');
      }

      setState(() {
        _topTracks = tracks;
        _topArtists = artists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadUserFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = _database.ref('users/${user.uid}');

      final tracksSnapshot = await userRef.child('favoriteTracks').get();
      final artistsSnapshot = await userRef.child('favoriteArtists').get();

      setState(() {
        if (tracksSnapshot.exists) {
          _favoriteTracks =
              List<String>.from(tracksSnapshot.value as List? ?? []);
        }

        if (artistsSnapshot.exists) {
          _favoriteArtists =
              List<String>.from(artistsSnapshot.value as List? ?? []);
        }
      });
    }
  }

  Future<void> _toggleTrackFavorite(Track track) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = _database.ref('users/${user.uid}');

      setState(() {
        if (_favoriteTracks.contains(track.id)) {
          _favoriteTracks.remove(track.id);
        } else {
          _favoriteTracks.add(track.id);
        }
      });

      await userRef.child('favoriteTracks').set(_favoriteTracks);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You need to be logged in to add favorites')),
      );
    }
  }

  Future<void> _toggleArtistFavorite(Artist artist) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = _database.ref('users/${user.uid}');

      setState(() {
        if (_favoriteArtists.contains(artist.id)) {
          _favoriteArtists.remove(artist.id);
        } else {
          _favoriteArtists.add(artist.id);
        }
      });

      await userRef.child('favoriteArtists').set(_favoriteArtists);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You need to be logged in to add favorites')),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Matcher'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimilarUsersScreen(),
                ),
              );
            },
            tooltip: 'Find similar users',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
            tooltip: 'Sign out',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Top Tracks'),
            Tab(text: 'Top Artists'),
            Tab(text: 'My Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Top Tracks Tab
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _topTracks.length,
                    itemBuilder: (context, index) {
                      final track = _topTracks[index];
                      final isFavorite = _favoriteTracks.contains(track.id);

                      return TrackCard(
                        track: track,
                        isFavorite: isFavorite,
                        onFavoriteToggle: () => _toggleTrackFavorite(track),
                      );
                    },
                  ),
                ),

          // Top Artists Tab
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _topArtists.length,
                    itemBuilder: (context, index) {
                      final artist = _topArtists[index];
                      final isFavorite = _favoriteArtists.contains(artist.id);

                      return ArtistCard(
                        artist: artist,
                        isFavorite: isFavorite,
                        onFavoriteToggle: () => _toggleArtistFavorite(artist),
                      );
                    },
                  ),
                ),

          // My Favorites Tab
          _buildFavoritesTab(),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    final hasFavorites =
        _favoriteTracks.isNotEmpty || _favoriteArtists.isNotEmpty;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!hasFavorites) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No favorites yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Like some tracks or artists to see them here',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _tabController.animateTo(0),
              child: const Text('Explore Tracks'),
            ),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Favorite Tracks'),
              Tab(text: 'Favorite Artists'),
            ],
            labelColor: Colors.blue,
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Favorite Tracks
                _favoriteTracks.isEmpty
                    ? const Center(child: Text('No favorite tracks yet'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _favoriteTracks.length,
                        itemBuilder: (context, index) {
                          final trackId = _favoriteTracks[index];
                          final track = _topTracks.firstWhere(
                            (t) => t.id == trackId,
                            orElse: () => Track(
                              id: trackId,
                              name: 'Loading...',
                              artist: 'Unknown',
                              imageUrl: '',
                            ),
                          );

                          return TrackCard(
                            track: track,
                            isFavorite: true,
                            onFavoriteToggle: () => _toggleTrackFavorite(track),
                          );
                        },
                      ),

                // Favorite Artists
                _favoriteArtists.isEmpty
                    ? const Center(child: Text('No favorite artists yet'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _favoriteArtists.length,
                        itemBuilder: (context, index) {
                          final artistId = _favoriteArtists[index];
                          final artist = _topArtists.firstWhere(
                            (a) => a.id == artistId,
                            orElse: () => Artist(
                              id: artistId,
                              name: 'Loading...',
                              imageUrl: '',
                              genres: [],
                            ),
                          );

                          return ArtistCard(
                            artist: artist,
                            isFavorite: true,
                            onFavoriteToggle: () =>
                                _toggleArtistFavorite(artist),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
