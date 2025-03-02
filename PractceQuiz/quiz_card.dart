import 'package:first_round/PractceQuiz/questions.dart';
import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final int id;
  final String name;
  final String qns;
  final int time;
  final String? description;

  const QuizCard({
    super.key,
    required this.id, 
    required this.name,
    required this.qns,
    required this.time,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    double totalTime = (int.parse(qns) * time) / 60.0;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (description != null)
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                Text(
                  'Total Questions: $qns',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Total Time: ${totalTime.toStringAsFixed(1)} minutes',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PQuestions(
                              quizId: id,
                              name: name,
                              time: time,
                            )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
