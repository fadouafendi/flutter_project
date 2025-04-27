import 'package:flutter/material.dart';

class SpotifyColors {
  // Spotify green
  static const int _spotifyGreenPrimaryValue = 0xFF1DB954;
  static const MaterialColor spotifyGreen = MaterialColor(
    _spotifyGreenPrimaryValue,
    <int, Color>{
      50: Color(0xFFE8FBEF),
      100: Color(0xFFC6F4D9),
      200: Color(0xFFA3EDC1),
      300: Color(0xFF80E3AA),
      400: Color(0xFF66D998),
      500: Color(_spotifyGreenPrimaryValue), // #1DB954
      600: Color(0xFF16A03E),
      700: Color(0xFF128A37),
      800: Color(0xFF0E742F),
      900: Color(0xFF06511F),
    },
  );

  // Dark background
  static const Color background = Color(0xFF191414);
  // Light text for contrast
  static const Color onBackground = Colors.white;
}
