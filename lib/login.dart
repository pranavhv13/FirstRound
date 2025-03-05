import 'package:first_round/functions/decrypt_password.dart';
import 'package:first_round/home.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isSignedIn = false;
  

  Future<void> signIn() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final String encryptedPassword = encryptString(password);
    try {
      final response = await supabase
          .from('auth')
          .select()
          .eq('user_id', username)
          .eq('password',encryptedPassword)
          .maybeSingle(); 

      if (response != null) {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      } else {
        showErrorMessage('Invalid username or password');
        setState(() {
          isSignedIn = false;
        });
      }
    } catch (e) {
      showErrorMessage('Error during sign-in: $e');
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FirstRound")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
