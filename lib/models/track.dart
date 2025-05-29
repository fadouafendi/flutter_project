class Track {
  final String id;
  final String name;
  final String artist;
  final String imageUrl;
  final String? previewUrl;
   bool isFavorite; 

  Track({
    required this.id,
    required this.name,
    required this.artist,
    required this.imageUrl,
    this.previewUrl,
    this.isFavorite = false,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    final images = json['album']['images'] as List;
    final imageUrl = images.isNotEmpty ? images[0]['url'] as String : '';
    return Track(
      id: json['id'] as String,
      name: json['name'] as String,
      artist: (json['artists'] as List).isNotEmpty
          ? json['artists'][0]['name'] as String
          : 'Unknown',
      imageUrl: imageUrl,
      previewUrl: json['preview_url'] as String?,
    );
  }
}
