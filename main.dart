import 'package:first_round/login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://rbnfqgqeyhgicdbcddvx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJibmZxZ3FleWhnaWNkYmNkZHZ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4MTgxMTQsImV4cCI6MjA1NjM5NDExNH0.GTJt0hzG-mscwZ6LEsSfbhaP49fcHR0CFUOhnqgZ2f8',
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
      home: const LoginPage(),
    );
  }
}
