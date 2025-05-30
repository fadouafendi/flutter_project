import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/track.dart';
import '../models/artist.dart';

class SpotifyService {
  static const String _baseUrl = 'https://api.spotify.com/v1';
  String? _accessToken;
  DateTime? _tokenExpiry;

  static String get _clientId {
    final id = dotenv.env['SPOTIFY_CLIENT_ID'];
    if (id == null || id.isEmpty) {
      throw StateError('SPOTIFY_CLIENT_ID not set in .env');
    }
    return id;
  }

  static String get _clientSecret {
    final secret = dotenv.env['SPOTIFY_CLIENT_SECRET'];
    if (secret == null || secret.isEmpty) {
      throw StateError('SPOTIFY_CLIENT_SECRET not set in .env');
    }
    return secret;
  }

  bool _debugMode = true;

  void _logDebug(String message) {
    if (_debugMode) {
      print('SpotifyService: $message');
    }
  }

  Future<String> _getAccessToken() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        _tokenExpiry!.isAfter(DateTime.now())) {
      return _accessToken!;
    }

    _logDebug('Getting new access token...');

    try {
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
        },
        body: {
          'grant_type': 'client_credentials',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['access_token'];
        _tokenExpiry =
            DateTime.now().add(Duration(seconds: data['expires_in']));
        _logDebug(
            'Got new access token, expires in ${data['expires_in']} seconds');
        return _accessToken!;
      } else {
        _logDebug(
            'Failed to get token: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to get Spotify access token: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      _logDebug('Exception getting token: $e');
      throw Exception('Network error while getting Spotify access token: $e');
    }
  }

  Future<List<Track>> getTopTracks() async {
    _logDebug('Fetching top tracks...');
    final trackIds = [
      '733c1CWmIGymoQXdp7Us88',
      '4t9PBD27dndlf6YMBK2ROc',
      '3XvcgEkQfjasB5NnY8P4QA',
      '6jezfOPKkARrn1J8AwHTE4',
      '7K5NiBQk7QJ0qehZ4e6LmB',
      '5R0EDMEBVlExLcofDAYvAD',
      '5JFk3TqqWnZenBewn7nqCW',
      '05gZLyOQphrQN86Jn2urCP',
      '0L0lFq8Dd9LfPhYKnQFTIA',
      '3LxZtMdZ05Tb2JqKER9OGO',
      '7EJjkhXp5o2xGvuFm2IqI7',
      '17Xxp5dtS4GmdGjNZNb5Gk',
      '5BqkqFLgC0CWCfkzNZ00Rz',
      '3UoE3IGTF6UUrUs8eM1BBY',
      '1dxIolWHHofTz5qGfrIK4I',
      '1ffOhN2G280aSIokZMoFPa',
      '7bpP75G6fdDkYE0lT2i7b4',
      '3pDBvuJnZG0LD2d3oDq59C',
      '4vn9db93kxdVJZ9yuybkpn',
      '54PDTMwcxLPDLb7iaPQauu',
      '2LBZakkMkYN1VtL2VVD5kX',
      '1i0MumkbZ4qK9Igosa0gfl',
      '7wCacjnlvU9ZN3uBNTKycs',
      '0wH14m3pTbudEnb8VSWNHy',
      '7w5fbYLaBtORuUewvs8atC',
      '0MBFyeMnnVWB3pU3ozQFbI',
      '7we1cUA1ycwqhSfLOjLD60',
      '0mxJO6v4kI05SK9KDyi1iw',
      '09f7w8W30zPHY5e48omn4K',
      '5RJIGWrj376fOY5i98XUc4',
      '1augprSFIh2VXJJfOEWlY8',
      '0pXOkvmWa7sA08Gyva1mga',
      '7pcEC5r1jVqWGRypo9D7f7',
      '26Z4ZAQqjy2B3d1WrTVbiL',
      '2ZgmyEc8yBcFMhFU0hBJ5P',
      '4Ih4yOeL3sB1D0Nma1tkpa',
      '6uCynRzxIgrh37JmjTT9Dp',
      '5nAgom0UphtfUw2cFc90p5',
      '3J6rHeMTDw8B7VUZoMBHyv',
      '5PnmcKgjWLWgpuX7U6o2QL',
      '0nNYp0EkTQf2NAMCwMgOwg',
      '2UuX1QUoLuEwQGNUTLdIik',
      '63o9SJH7EYh4ztYFe4Fevj',
      '6b294w610LEavCkgWOMqm7',
      '4FxpTvKA8ikVafy9lA0FG2',
      '1dmkT7HDBxkA7VHlwCNHtE',
      '5QXiHzrMyDKmeqMXXX14rm',
      '6X5ZKhUxvsTRG0172oOskq',
      '0BiMfnkXFkAHM0DqSPmcB9',
      '6Cg6XzJWNz1xVeieCQ3kIE'
    ];

    try {
      final token = await _getAccessToken();
      final trackIdsString = trackIds.join(',');

      final response = await http.get(
        Uri.parse('$_baseUrl/tracks?ids=$trackIdsString&market=fr'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        _logDebug(
            'Failed to get tracks: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load tracks: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data['tracks'] == null) {
        _logDebug('Unexpected response format: ${response.body}');
        return [];
      }

      final tracksData = data['tracks'] as List;
      _logDebug('Got ${tracksData.length} tracks');

      List<Track> tracks = [];

      for (var trackData in tracksData) {
        if (trackData == null) continue;

        try {
          tracks.add(Track.fromJson(trackData));
        } catch (e) {
          _logDebug('Error parsing track: $e');
        }

        if (tracks.length >= 20) break;
      }

      _logDebug('Returning ${tracks.length} tracks');
      return tracks;
    } catch (e) {
      _logDebug('Exception in getTopTracks: $e');
      throw Exception('Failed to load top tracks: $e');
    }
  }

  Future<List<Artist>> getTopArtists() async {
    _logDebug('Fetching top artists...');
    final artistIds = [
      '18BQ9fx7wYhHQhFmOuZctu',
      '7yURu3gRxmCReoYCg8m5M9',
      '1ZwdS5xdxEREPySFridCfh',
      '3kYFawNQVZ00FQbgs4rVBe',
      '0bQ6GmDl8knaIr3fwCWZ6j',
      '0KlSW3j5fUEfej47FOrBMr',
      '6Xb4ezwoAQC4516kI89nWz',
      '1tWBEFYkWnb4CXo8Edz2u2',
      '0lzz7vFjUA0jCmEy1PR53a',
      '2mdiJjMYSWQoqoSP8sFiFZ',
      '1JOdUvDAzNy3L37rZ4Nigr',
      '0LcJLqbBmaGUft1e9Mm8HV',
      '1rSGNXhhYuWoq9BEz5DZGO',
      '2pC61A8jBdvqKbB429A7yg',
      '0du5cEVh5yTK9QJze8zA0C',
      '3Isy6kedDrgPYoTS1dazA9',
      '44NX2ffIYHr6D4n7RaZF7A',
      '1LTL2bMTVsdeVgE425j98M',
      '6DUKY45lfzxJLOfU0v9C0j',
      '35l9BRT7MXmM8bv2WDQiyB',
      '6MOueeAGmy8g8Ir3MLeO4o',
      '77ziqFxp5gaInVrF2lj4ht',
      '3gMrpwNrFNI5p6iz9IeUrs',
      '4CNfRyL59In8QRz94NE63M',
      '2CvCyf1gEVhI0mX6aFXmVI',
      '6A6DsWl9R5fisVkGD8A9mo',
      '7Ln80lUS6He07XvHI8qqHH',
      '4KWTAlx2RvbpseOGMEmROg',
      '304g0c1IvTZjo2V19MSTiG',
      '3rtvvt1kuQ4luEWq8epaHD',
      '3dRfiJ2650SZu6GbydcHNb',
      '7tYKF4w9nC0nq9CsPZTHyP',
      '3kdCESHby2JeZ7Ve0cC8up',
      '7MiDcPa6UiV3In7lIM71IN',
      '1DUdW31m7wIqrcSYTaT4zp',
      '2MdpP77DjF160zQ7nnzyKv',
      '6eUKZXaKkcviH0Ku9w2n3V',
      '0bfX8pF8kuHNCs57Ms4jZb',
      '0zx8yW9E6H5pwqAnWrDepm',
      '422Lh8pIc1aZMeF3xnf4Dt',
      '0OcclcP5o8VKH2TRqSY2A7',
      '1McMsnEElThX1knmY4oliG',
      '7HNpdpSzEr0e88c60UTUEJ',
      '1AL2GKpmRrKXkYIcASuRFa',
      '1XRrYWnoRIqMuQHq1npqSK',
      '2s1Uh7FMg16611brgIIPTU',
      '6qqNVTkY8uBg9cP3Jd7DAH',
      '4FtSnMlCVxCswABUmdhwpm',
      '5s63e3kqhaHRc0Lnbqcgjj',
      '4hz8ohK9ESaFbJBAXvWJGL'
    ];

    try {
      final token = await _getAccessToken();
      final artistIdsString = artistIds.join(',');

      final response = await http.get(
        Uri.parse('$_baseUrl/artists?ids=$artistIdsString'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        _logDebug(
            'Failed to get artists: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load artists: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data['artists'] == null) {
        _logDebug('Unexpected response format: ${response.body}');
        return [];
      }

      final artistsData = data['artists'] as List;
      _logDebug('Got ${artistsData.length} artists');

      List<Artist> artists = [];

      for (var artistData in artistsData) {
        if (artistData == null) continue;

        try {
          artists.add(Artist.fromJson(artistData));
        } catch (e) {
          _logDebug('Error parsing artist: $e');
        }

        if (artists.length >= 20) break;
      }

      _logDebug('Returning ${artists.length} artists');
      return artists;
    } catch (e) {
      _logDebug('Exception in getTopArtists: $e');
      throw Exception('Failed to load top artists: $e');
    }
  }

  Future<Track> getTrackById(String trackId) async {
    _logDebug('Fetching track by ID: $trackId');

    try {
      final token = await _getAccessToken();

      final response = await http.get(
        Uri.parse('$_baseUrl/tracks/$trackId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        _logDebug(
            'Failed to get track $trackId: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load track: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      return Track.fromJson(data);
    } catch (e) {
      _logDebug('Exception in getTrackById: $e');
      throw Exception('Failed to load track: $e');
    }
  }

  Future<Artist> getArtistById(String artistId) async {
    _logDebug('Fetching artist by ID: $artistId');

    try {
      final token = await _getAccessToken();

      final response = await http.get(
        Uri.parse('$_baseUrl/artists/$artistId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        _logDebug(
            'Failed to get artist $artistId: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load artist: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      return Artist.fromJson(data);
    } catch (e) {
      _logDebug('Exception in getArtistById: $e');
      throw Exception('Failed to load artist: $e');
    }
  }
}
