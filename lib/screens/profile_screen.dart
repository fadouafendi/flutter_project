import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: user == null
          ? const Center(child: Text('No user logged in'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.person, size: 100),
                  const SizedBox(height: 16),
                  Text(user.displayName ?? 'No Name',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text(user.email ?? '',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
    );
  }
}
