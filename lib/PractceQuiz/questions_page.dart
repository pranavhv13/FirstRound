import 'dart:async';
import 'package:first_round/PractceQuiz/answers_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PQuestions extends StatefulWidget {
  final int quizId;
  final String name;
  final int time;

  const PQuestions({
    super.key,
    required this.quizId,
    required this.name,
    required this.time,
  });

  @override
  State<PQuestions> createState() => _PQuestionsState();
}

class _PQuestionsState extends State<PQuestions> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  String? selectedOption;
  Map<int, String?> userAnswers = {};
  int totalTimeTaken = 0;

  Timer? questionTimer;
  int remainingTime = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final response = await Supabase.instance.client
        .from('practice_quiz_questions')
        .select()
        .eq('quiz_id', widget.quizId);

    setState(() {
      questions = List<Map<String, dynamic>>.from(response);
    });

    if (questions.isNotEmpty) {
      startQuestionTimer();
    }
  }

  void startQuestionTimer() {
    remainingTime = widget.time;
    questionTimer?.cancel();
    questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
          totalTimeTaken++;
        } else {
          timer.cancel();
          goToNextQuestion();
        }
      });
    });
  }

  void goToNextQuestion() {
    userAnswers[currentQuestionIndex] = selectedOption;

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
        startQuestionTimer();
      });
    } else {
      questionTimer?.cancel();
      showResultDialog();
    }
  }

  // Maps A, B, C, D to 1, 2, 3, 4 to match correct_option
  int mapOptionToNumber(String? option) {
    switch (option) {
      case 'A':
        return 1;
      case 'B':
        return 2;
      case 'C':
        return 3;
      case 'D':
        return 4;
      default:
        return 0; // For null or invalid options
    }
  }

  // Calculate score by comparing user answers (A/B/C/D) to correct_option (1/2/3/4)
  int calculateScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      final correctAnswer = questions[i]['correct_option'];
      final userSelectedOption = userAnswers[i];

      if (userSelectedOption == null) continue; // Skip unanswered questions

      final userSelectedNumber = mapOptionToNumber(userSelectedOption);

      if (userSelectedNumber == correctAnswer) {
        score++;
      }
    }
    return score;
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void showResultDialog() {
    final score = calculateScore();
    String formattedTotalTime = formatTime(totalTimeTaken);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Completed'),
          content: Text(
            'You scored $score out of ${questions.length}\n\n'
            'Total Time Taken: $formattedTotalTime',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to previous screen
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswersPage(
                      questions: questions,
                      userAnswers: userAnswers,
                    ),
                  ),
                );
              },
              child: const Text('View Answers'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.timer, size: 24),
                const SizedBox(width: 5),
                Text(formatTime(remainingTime),
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q${currentQuestionIndex + 1}: ${question['question']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildOption('A', question['option_a']),
            buildOption('B', question['option_b']),
            buildOption('C', question['option_c']),
            buildOption('D', question['option_d']),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: selectedOption != null ? goToNextQuestion : null,
                child: Text(currentQuestionIndex < questions.length - 1
                    ? 'Next'
                    : 'Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(String optionKey, String optionText) {
    return ListTile(
      title: Text('$optionKey) $optionText'),
      leading: Radio<String>(
        value: optionKey,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    questionTimer?.cancel();
    super.dispose();
  }
}
