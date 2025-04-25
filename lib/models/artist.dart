class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> genres;
  final int? popularity;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genres,
    this.popularity,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List;
    final imageUrl = images.isNotEmpty ? images[0]['url'] as String : '';

    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: imageUrl,
      genres:
          (json['genres'] as List?)?.map((genre) => genre as String).toList() ??
              [],
      popularity: json['popularity'] as int?,
    );
  }
}
