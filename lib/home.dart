import 'package:first_round/PractceQuiz/category_card.dart';
import 'package:first_round/PractceQuiz/practice_quiz_page.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Quizzes'),
      ),
      body: ListView(),
    );
  }
}

class PracticeQuizPage extends StatefulWidget {
  const PracticeQuizPage({super.key});

  @override
  State<PracticeQuizPage> createState() => _PracticeQuizHomePageState();
}

class _PracticeQuizHomePageState extends State<PracticeQuizPage> {
  late Future<List<Map<String, dynamic>>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchPracticeCategories();
  }

  Future<List<Map<String, dynamic>>> fetchPracticeCategories() async {
    final response = await supabase
        .from('practice_categories')
        .select()
        .order('category_id', ascending: true);

    if (response.isEmpty) {
      return [];
    }

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Quiz Categories')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Categories Found'));
          }

          final categories = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return CategoryCard(
                  categoryName: category['name'] ?? 'Unnamed',
                  colorHex: category['color_hex'] ?? '#6200EE', // Default color
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PracticeQuizListPage(
                          categoryId: category['category_id'],
                          categoryName: category['name'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
