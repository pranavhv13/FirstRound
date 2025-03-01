import 'package:first_round/login.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void signOut(BuildContext context) {
    // Navigate back to LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
