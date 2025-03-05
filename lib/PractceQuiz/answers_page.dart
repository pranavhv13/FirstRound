import 'package:flutter/material.dart';

class AnswersPage extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final Map<int, String?> userAnswers;

  const AnswersPage({
    super.key,
    required this.questions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Answers')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final correctAnswer = question['correct_option'];
          final userAnswer = userAnswers[index] ?? 'No Answer';
          final convert = ['X','A','B','C','D'];
          final validAnswer = convert[correctAnswer];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${index + 1}: ${question['question']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('A) ${question['option_a']}'),
                  Text('B) ${question['option_b']}'),
                  Text('C) ${question['option_c']}'),
                  Text('D) ${question['option_d']}'),
                  const SizedBox(height: 8),
                  Text('Your Answer: $userAnswer'),
                  Text('Correct Answer: $validAnswer',
                      style: TextStyle(
                          color: userAnswer == correctAnswer
                              ? Colors.green
                              : Colors.red)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
