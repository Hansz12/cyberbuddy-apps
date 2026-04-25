import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import 'root_screen.dart';

class PostTestScreen extends StatefulWidget {
  const PostTestScreen({super.key});

  @override
  State<PostTestScreen> createState() => _PostTestScreenState();
}

class _PostTestScreenState extends State<PostTestScreen> {
  final Map<int, int> selectedAnswers = {};

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the safest action before clicking an unknown link?',
      'options': [
        'Click it quickly',
        'Verify the sender and URL',
        'Share it with friends',
        'Ignore all security warnings',
      ],
      'answer': 1,
    },
    {
      'question': 'Which password habit is the safest?',
      'options': [
        'Use the same password everywhere',
        'Use your birthday',
        'Use unique strong passwords',
        'Share password with friends',
      ],
      'answer': 2,
    },
    {
      'question': 'What should you do if you suspect malware?',
      'options': [
        'Ignore it',
        'Install more unknown APKs',
        'Scan device and remove suspicious apps',
        'Turn off all updates',
      ],
      'answer': 2,
    },
    {
      'question': 'Why should users protect personal information online?',
      'options': [
        'To avoid identity misuse',
        'To make accounts public',
        'To increase spam',
        'To make phishing easier',
      ],
      'answer': 0,
    },
    {
      'question': 'What should you do after a cyber incident?',
      'options': [
        'Do nothing',
        'Report it and keep evidence',
        'Delete everything immediately',
        'Post private details online',
      ],
      'answer': 1,
    },
  ];

  Future<void> _submitPostTest() async {
    int correct = 0;

    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['answer']) {
        correct++;
      }
    }

    final score = ((correct / questions.length) * 100).round();
    final cubit = context.read<AppCubit>();

    await cubit.completePostTest(score);

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Post-Test Completed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _resultRow('Correct Answers', '$correct/${questions.length}'),
              _resultRow('Post-Test Score', '$score%'),
              _resultRow('Pre-Test Score', '${cubit.state.preTestScore}%'),
              _resultRow('Improvement', '${cubit.improvementScore}%'),
              _resultRow('Awareness', cubit.postTestAwarenessLevel),
              _resultRow('Risk Level', cubit.postTestRiskLevel),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  cubit.evaluationFeedback,
                  style: const TextStyle(height: 1.4),
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AppCubit>(),
          child: const RootScreen(),
        ),
      ),
          (route) => false,
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final answeredAll = selectedAnswers.length == questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post-Test'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerCard(),
              const SizedBox(height: 16),
              Text(
                'Answered: ${selectedAnswers.length}/${questions.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...List.generate(questions.length, (index) {
                final question = questions[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}',
                          style: TextStyle(
                            color: Colors.indigo.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          question['question'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(
                          (question['options'] as List).length,
                              (optionIndex) {
                            return RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              value: optionIndex,
                              groupValue: selectedAnswers[index],
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswers[index] = value!;
                                });
                              },
                              title: Text(
                                question['options'][optionIndex],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: answeredAll ? _submitPostTest : null,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Finish Post-Test'),
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

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.fact_check_outlined,
            color: Colors.white,
            size: 36,
          ),
          SizedBox(height: 14),
          Text(
            'Cybersecurity Post-Test',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Complete this assessment to evaluate your awareness after using CyberBuddy.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }
}