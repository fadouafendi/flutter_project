import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Sign in to continue',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 40),
                if (auth.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red.shade50,
                    child: Text(
                      auth.errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  enabled: !auth.isLoading,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                  enabled: !auth.isLoading,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          await context.read<AuthProvider>().signIn(
                                _emailController.text.trim(),
                                _passwordController.text,
                              );
                        },
                  child: auth.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white)),
                        )
                      : const Text('Sign In'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('- Or sign in with -'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Image.asset('assets/google.png', height: 24),
                  onPressed: auth.isLoading
                      ? null
                      : () => context.read<AuthProvider>().signInWithGoogle(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
