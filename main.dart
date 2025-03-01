import 'package:first_round/login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://rbnfqgqeyhgicdbcddvx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJibmZxZ3FleWhnaWNkYmNkZHZ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4MTgxMTQsImV4cCI6MjA1NjM5NDExNH0.GTJt0hzG-mscwZ6LEsSfbhaP49fcHR0CFUOhnqgZ2f8',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isSignedIn = false;

  Future<void> _signIn() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    try {
      final response = await supabase
          .from('auth') // Assuming you have a custom 'auth' table
          .select()
          .eq('user_id', username)
          .eq('password', password)
          .maybeSingle(); // Return null if no match found

      if (response != null) {
        print('Sign-in successful for user: $username');
        setState(() {
          isSignedIn = true;
        });
      } else {
        print('Invalid credentials');
        setState(() {
          isSignedIn = false;
        });
      }
    } catch (e) {
      print('Error during sign-in: $e');
    }
  }

  void _signOut() {
    setState(() {
      isSignedIn = false;
    });
    print('Sign-out successful');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Supabase Custom Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.black), // Text visible
                filled: true,
                fillColor: Colors.white, // Background color
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black), // Typed text color
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Sign Out'),
            ),
            SizedBox(height: 20),
            Text(
              isSignedIn ? 'Signed In' : 'Signed Out',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
