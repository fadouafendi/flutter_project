# SpotyPoty

A simple Flutter music app with Firebase authentication and Spotify integration.

## Implemented Features

- **Authentication**
  - Email/password sign-up & login (with form validation and error messages)
  - Google Sign-In
  - Auth-state wrapper with loading indicator
- **User Profile**
  - Profile screen showing user’s display name & email
  - Logout
- **Music Content**
  - Fetch “top” tracks & artists via Spotify API (client-credentials flow)
  - List screens for Tracks and Artists
  - Detail screens with Hero animations, cover image, name, metadata (genres, popularity)
- **Navigation**
  - BottomNavigationBar to switch between Tracks & Artists
  - AppDrawer with Profile & Logout entries
- **State Management**
  - `Provider` for auth state & Spotify data
- **Theming & Layout**
  - Dark theme with Spotify-green accent
  - Consistent padding and centered detail screens
- **Configuration**
  - Firebase integration for auth
  - Environment variables via `flutter_dotenv` for Spotify credentials
