import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/profile_cubit.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  bool? isAnsweredCorrectly;
  bool quizFinished = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Is "P@ssword123" considered a strong and secure password?',
      'answer': false,
      'explanation':
          'Weak! Common words and numbers are easily cracked by hackers.',
    },
    {
      'question':
          'Can a phishing link come from a friend\'s hacked email account?',
      'answer': true,
      'explanation':
          'Yes! Hackers use compromised accounts to gain your trust.',
    },
    {
      'question':
          'You should always check the sender\'s email address before clicking a link.',
      'answer': true,
      'explanation':
          'Correct! Domain names are often slightly misspelled in scams.',
    },
  ];

  void _handleAnswer(bool userSelection) {
    if (isAnsweredCorrectly != null) return; // Prevent double tapping

    setState(() {
      isAnsweredCorrectly =
          userSelection == questions[currentQuestionIndex]['answer'];
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (currentQuestionIndex < questions.length - 1) {
          setState(() {
            currentQuestionIndex++;
            isAnsweredCorrectly = null;
          });
        } else {
          setState(() {
            quizFinished = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text(
          "Cyber Mission",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: quizFinished ? _buildSummary(context) : _buildQuiz(progress),
    );
  }

  Widget _buildQuiz(double progress) {
    final currentQ = questions[currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // 1. Progress Indicator
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF3F51B5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Question ${currentQuestionIndex + 1} of ${questions.length}",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // 2. Question Card
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.security_rounded,
                  size: 48,
                  color: Color(0xFF3F51B5),
                ),
                const SizedBox(height: 24),
                Text(
                  currentQ['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 3. Feedback Text
          if (isAnsweredCorrectly != null)
            _buildFeedback(isAnsweredCorrectly!, currentQ['explanation']),

          const Spacer(),

          // 4. Answer Buttons
          Row(
            children: [
              Expanded(
                child: _buildAnswerButton("FALSE", false, Colors.redAccent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnswerButton(
                  "TRUE",
                  true,
                  Colors.greenAccent[700]!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFeedback(bool isCorrect, String explanation) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.error,
            color: isCorrect ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              explanation,
              style: TextStyle(
                color: isCorrect ? Colors.green[800] : Colors.red[800],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(String label, bool value, Color color) {
    bool isChosen =
        isAnsweredCorrectly != null &&
        value == questions[currentQuestionIndex]['answer'];

    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(
            color: isChosen ? color : Colors.transparent,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        onPressed: () => _handleAnswer(value),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars_rounded, size: 100, color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              "Mission Accomplished!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "You've enhanced your digital awareness and earned experience points.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F51B5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                context.read<ProfileCubit>().addProgress(100, null);
                Navigator.pop(context);
              },
              child: const Text(
                "Collect 100 XP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<ProfileCubit>().addProgress(0, 'phishing');
                Navigator.pop(context);
              },
              child: const Text(
                "Simulate Fail (Test Recommendation)",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
