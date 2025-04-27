import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Full Name', border: OutlineInputBorder()),
                enabled: !auth.isLoading,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              TextField(
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder()),
                enabled: !auth.isLoading,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        if (_passwordController.text !=
                            _confirmController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Passwords do not match')),
                          );
                          return;
                        }
                        await context.read<AuthProvider>().signUp(
                              _emailController.text.trim(),
                              _passwordController.text,
                              _nameController.text.trim(),
                            );
                      },
                child: auth.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : const Text('Sign Up'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('- Or sign up with -'),
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
    );
  }
}
