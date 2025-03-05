import 'package:first_round/PractceQuiz/quiz_card.dart';
import 'package:first_round/main.dart';
import 'package:flutter/material.dart';

class PracticeQuizListPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const PracticeQuizListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<PracticeQuizListPage> createState() => _PracticeQuizListPageState();
}

class _PracticeQuizListPageState extends State<PracticeQuizListPage> {
  late Future<List<Map<String, dynamic>>> quizzesFuture;

  @override
  void initState() {
    super.initState();
    quizzesFuture = fetchPracticeQuizzes();
  }

  Future<List<Map<String, dynamic>>> fetchPracticeQuizzes() async {
    final response = await supabase
        .from('practice_quiz')
        .select()
        .eq('category_id', widget.categoryId);

    if (response.isEmpty) {
      return [];
    }

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
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
