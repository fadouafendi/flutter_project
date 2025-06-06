import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:SpotyPoty/firebase_options.dart';
import 'package:SpotyPoty/screens/favorites_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/spotify_provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/track_detail_screen.dart';
import 'screens/artist_detail_screen.dart';

import 'package:SpotyPoty/theme/spotify_colors.dart';

Future<FirebaseApp> _initFirebase() async {
  try {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      return Firebase.app();
    }
    rethrow;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await _initFirebase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SpotifyProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpotyPoty',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: SpotifyColors.spotifyGreen,
        scaffoldBackgroundColor: SpotifyColors.background,
        colorScheme: ColorScheme.dark(
          primary: SpotifyColors.spotifyGreen,
          onPrimary: SpotifyColors.onBackground,
          background: SpotifyColors.background,
          onBackground: SpotifyColors.onBackground,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: SpotifyColors.background,
          foregroundColor: SpotifyColors.spotifyGreen,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: SpotifyColors.background,
          selectedItemColor: SpotifyColors.spotifyGreen,
          unselectedItemColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: SpotifyColors.onBackground,
            backgroundColor: SpotifyColors.spotifyGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: SpotifyColors.onBackground),
          bodyMedium: TextStyle(color: SpotifyColors.onBackground),
          titleMedium: TextStyle(color: Colors.grey[400]),
        ),
      ),
      routes: {
        '/login': (_) => LoginScreen(),
        '/signup': (_) => SignupScreen(),
        '/profile': (_) => ProfileScreen(),
        '/trackDetail': (_) => TrackDetailScreen(),
        '/artistDetail': (_) => ArtistDetailScreen(),
        '/main-screen': (_) => HomeScreen(),
      },
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return auth.user == null ? LoginScreen() : HomeScreen();
  }
}
