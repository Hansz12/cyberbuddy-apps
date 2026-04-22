import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';

class PostTestScreen extends StatefulWidget {
  const PostTestScreen({super.key});

  @override
  State<PostTestScreen> createState() => _PostTestScreenState();
}

class _PostTestScreenState extends State<PostTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What should you do before clicking a suspicious email link?',
      'options': [
        'Click immediately',
        'Ignore everything forever',
        'Verify sender and URL',
        'Reply with account details'
      ],
      'answer': 2,
    },
    {
      'question': 'Why is password reuse dangerous?',
      'options': [
        'It makes login faster',
        'One leaked password can expose multiple accounts',
        'It improves account safety',
        'Apps require the same password'
      ],
      'answer': 1,
    },
    {
      'question': 'What should you do after noticing suspicious account activity?',
      'options': [
        'Do nothing',
        'Change password and report the incident',
        'Post it publicly first',
        'Delete all apps'
      ],
      'answer': 1,
    },
  ];

  final Map<int, int> selectedAnswers = {};

  void _submitPostTest() {
    int total = 0;

    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['answer']) {
        total += 1;
      }
    }

    final percentScore = ((total / questions.length) * 100).round();
    final cubit = context.read<AppCubit>();

    cubit.completePostTest(percentScore);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Post-Test Completed'),
        content: SingleChildScrollView(
          child: Text(
            'Pre-Test Score: ${cubit.state.preTestScore}%\n'
                'Post-Test Score: $percentScore%\n'
                'Improvement: ${cubit.improvementScore}%\n'
                'Awareness Level: ${cubit.postTestAwarenessLevel}\n'
                'Risk Level: ${cubit.postTestRiskLevel}\n\n'
                '${cubit.evaluationFeedback}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post-Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Cybersecurity Awareness Post-Test',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Answer the questions below to evaluate your learning progress after using the application.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...List.generate(questions.length, (index) {
              final question = questions[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['question'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        (question['options'] as List).length,
                            (optionIndex) {
                          return RadioListTile<int>(
                            value: optionIndex,
                            groupValue: selectedAnswers[index],
                            onChanged: (value) {
                              setState(() {
                                selectedAnswers[index] = value!;
                              });
                            },
                            title: Text(question['options'][optionIndex]),
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
              child: FilledButton(
                onPressed: selectedAnswers.length == questions.length
                    ? _submitPostTest
                    : null,
                child: const Text('Finish Post-Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}