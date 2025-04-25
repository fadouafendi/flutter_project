import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SimilarUsersScreen extends StatefulWidget {
  const SimilarUsersScreen({Key? key}) : super(key: key);

  @override
  _SimilarUsersScreenState createState() => _SimilarUsersScreenState();
}

class _SimilarUsersScreenState extends State<SimilarUsersScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool _isLoading = true;
  List<Map<String, dynamic>> _similarUsers = [];

  @override
  void initState() {
    super.initState();
    _findSimilarUsers();
  }

  Future<void> _findSimilarUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Get current user's favorites
      final userRef = _database.ref('users/${currentUser.uid}');
      final userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final userData = userSnapshot.value as Map<dynamic, dynamic>;
      final currentUserFavoriteTracks =
          List<String>.from(userData['favoriteTracks'] ?? []);
      final currentUserFavoriteArtists =
          List<String>.from(userData['favoriteArtists'] ?? []);

      // Get all users
      final usersSnapshot = await _database.ref('users').get();

      if (!usersSnapshot.exists) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final usersData = usersSnapshot.value as Map<dynamic, dynamic>;

      List<Map<String, dynamic>> similarUsers = [];

      // Calculate similarity for each user
      usersData.forEach((userId, userData) {
        // Skip current user
        if (userId == currentUser.uid) return;

        final userFavoriteTracks =
            List<String>.from(userData['favoriteTracks'] ?? []);
        final userFavoriteArtists =
            List<String>.from(userData['favoriteArtists'] ?? []);

        // Calculate track similarity
        final commonTracks = currentUserFavoriteTracks
            .where((track) => userFavoriteTracks.contains(track))
            .length;
        final totalUniqueTracks = Set<String>.from([
          ...currentUserFavoriteTracks,
          ...userFavoriteTracks,
        ]).length;

        // Calculate artist similarity
        final commonArtists = currentUserFavoriteArtists
            .where((artist) => userFavoriteArtists.contains(artist))
            .length;
        final totalUniqueArtists = Set<String>.from([
          ...currentUserFavoriteArtists,
          ...userFavoriteArtists,
        ]).length;

        // Calculate overall similarity percentage
        double similarity = 0;
        if (totalUniqueTracks > 0 || totalUniqueArtists > 0) {
          final trackSimilarity =
              totalUniqueTracks > 0 ? commonTracks / totalUniqueTracks : 0;
          final artistSimilarity =
              totalUniqueArtists > 0 ? commonArtists / totalUniqueArtists : 0;

          // Weight artists and tracks equally
          similarity = (trackSimilarity + artistSimilarity) / 2 * 100;
        }

        // Only include users with >80% similarity
        if (similarity >= 80) {
          similarUsers.add({
            'userId': userId,
            'email': userData['email'] ?? 'Unknown',
            'similarity': similarity,
            'commonTracks': commonTracks,
            'commonArtists': commonArtists,
          });
        }
      });

      // Sort by similarity (highest first)
      similarUsers.sort((a, b) => b['similarity'].compareTo(a['similarity']));

      setState(() {
        _similarUsers = similarUsers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Similar Users'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _similarUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_outline,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No similar users found',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add more favorites to find users with similar taste',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _findSimilarUsers,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _findSimilarUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _similarUsers.length,
                    itemBuilder: (context, index) {
                      final user = _similarUsers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(user['email']
                                .toString()
                                .substring(0, 1)
                                .toUpperCase()),
                          ),
                          title: Text(user['email']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Similarity: ${user['similarity'].toStringAsFixed(1)}%'),
                              Text('Common tracks: ${user['commonTracks']}'),
                              Text('Common artists: ${user['commonArtists']}'),
                            ],
                          ),
                          trailing: const Icon(Icons.person),
                          onTap: () {
                            // You could implement a user profile view here
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
