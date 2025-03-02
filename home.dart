import 'package:first_round/PractceQuiz/quiz_card.dart';
import 'package:first_round/main.dart';
import 'package:flutter/material.dart';
import 'package:first_round/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    const PracticeQuizPage(),
    const LiveQuizPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void signOut(BuildContext context) {
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
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Practice Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Live Quiz',
          ),
        ],
      ),
    );
  }
}

class LiveQuizPage extends StatelessWidget {
  const LiveQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Live Quiz Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class PracticeQuizPage extends StatefulWidget {
  const PracticeQuizPage({super.key});

  @override
  State<PracticeQuizPage> createState() => _PracticeQuizPageState();
}

class _PracticeQuizPageState extends State<PracticeQuizPage> {
  late Future<List<Map<String, dynamic>>> quizzesFuture;

  @override
  void initState() {
    super.initState();
    quizzesFuture = fetchPracticeQuizzes();
  }

  Future<List<Map<String, dynamic>>> fetchPracticeQuizzes() async {
    final response = await supabase.from('practice_quiz').select();

    if (response.isEmpty) {
      return [];
    }

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Quizzes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: quizzesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Quizzes Found'));
          }

          final quizzes = snapshot.data!;

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return QuizCard(
                id: quiz['id'],
                name: quiz['name'] ?? 'Unnamed Quiz',
                qns: quiz['total_qns'].toString(),
                time: quiz['time'],
                description: quiz['description'],
              );
            },
          );
        },
      ),
    );
  }
}
