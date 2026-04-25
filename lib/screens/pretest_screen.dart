import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import 'root_screen.dart';

class PreTestScreen extends StatefulWidget {
  const PreTestScreen({super.key});

  @override
  State<PreTestScreen> createState() => _PreTestScreenState();
}

class _PreTestScreenState extends State<PreTestScreen> {
  int currentIndex = 0;
  int score = 0;
  int? selected;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is phishing?',
      'options': [
        'A hacking tool',
        'A scam to steal personal info',
        'A security software',
        'A network protocol',
      ],
      'answer': 1,
    },
    {
      'question': 'Which password is strong?',
      'options': ['123456', 'password', 'T!mE#84xP', 'abc123'],
      'answer': 2,
    },
    {
      'question': 'What should you avoid downloading?',
      'options': [
        'Official apps',
        'Unknown APK files',
        'Play Store apps',
        'Updates',
      ],
      'answer': 1,
    },
    {
      'question': 'Why is privacy important?',
      'options': [
        'For fun',
        'To prevent data misuse',
        'To share data',
        'To speed internet',
      ],
      'answer': 1,
    },
    {
      'question': 'What should you do after account hacked?',
      'options': [
        'Ignore it',
        'Change password immediately',
        'Post online first',
        'Delete the app only',
      ],
      'answer': 1,
    },
  ];

  Future<void> nextQuestion() async {
    if (selected == null) return;

    if (selected == questions[currentIndex]['answer']) {
      score += 20;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selected = null;
      });
    } else {
      await context.read<AppCubit>().completePreTest(score);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RootScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-Test'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${currentIndex + 1}/${questions.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                q['question'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                (q['options'] as List).length,
                    (index) {
                  return Card(
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: selected,
                      onChanged: (val) {
                        setState(() {
                          selected = val;
                        });
                      },
                      title: Text(q['options'][index]),
                    ),
                  );
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: selected == null ? null : nextQuestion,
                  child: Text(
                    currentIndex == questions.length - 1
                        ? 'Finish Pre-Test'
                        : 'Next',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}