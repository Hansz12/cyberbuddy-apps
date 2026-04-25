import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int correctCount = 0;
  int wrongCount = 0;
  int pointsEarned = 0;

  Future<void> _submitAnswer(BuildContext context) async {
    final cubit = context.read<AppCubit>();
    final state = cubit.state;
    final quiz = cubit.currentQuiz;

    if (state.selectedAnswer == null || quiz.isEmpty) return;

    final currentQuestion = quiz[state.quizIndex];
    final isCorrect = state.selectedAnswer == currentQuestion.answerIndex;

    if (isCorrect) {
      correctCount++;
      pointsEarned += 20;
    } else {
      wrongCount++;
    }

    await cubit.submitAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = context.read<AppCubit>();
        final quiz = cubit.currentQuiz;
        final module = state.selectedModule;

        if (module == null) {
          return const Scaffold(
            body: Center(child: Text('No module selected')),
          );
        }

        if (quiz.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Quiz')),
            body: const Center(
              child: Text('No quiz questions available for this module.'),
            ),
          );
        }

        if (state.quizDone) {
          final total = correctCount + wrongCount;
          final score = total == 0 ? 0 : ((correctCount / total) * 100).round();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Quiz Result'),
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.emoji_events_outlined,
                            color: Colors.white,
                            size: 52,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Quiz Completed!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            module.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _resultCard(
                            label: 'Score',
                            value: '$score%',
                            icon: Icons.bar_chart,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _resultCard(
                            label: 'Points',
                            value: '+$pointsEarned',
                            icon: Icons.star_outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _resultCard(
                            label: 'Correct',
                            value: '$correctCount',
                            icon: Icons.check_circle_outline,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _resultCard(
                            label: 'Wrong',
                            value: '$wrongCount',
                            icon: Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          score >= 80
                              ? 'Great work! You have shown strong understanding of this cybersecurity topic.'
                              : score >= 50
                              ? 'Good attempt. Review this topic again to strengthen your understanding.'
                              : 'This topic may need more practice. CyberBuddy will consider it as a weak topic for recommendation.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          await cubit.finishQuizBackHome();

                          if (!context.mounted) return;

                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.home_outlined),
                        label: const Text('Back to Home'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final question = quiz[state.quizIndex];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Quiz'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: (state.quizIndex + 1) / quiz.length,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.indigo,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Question ${state.quizIndex + 1}/${quiz.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(question.options.length, (index) {
                    final selected = state.selectedAnswer == index;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: RadioListTile<int>(
                        value: index,
                        groupValue: state.selectedAnswer,
                        onChanged: (value) {
                          if (value != null) {
                            cubit.selectAnswer(value);
                          }
                        },
                        title: Text(question.options[index]),
                        activeColor: Colors.indigo,
                        selected: selected,
                      ),
                    );
                  }),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: state.selectedAnswer == null
                          ? null
                          : () => _submitAnswer(context),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        state.quizIndex == quiz.length - 1
                            ? 'Finish Quiz'
                            : 'Next Question',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _resultCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.indigo, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}