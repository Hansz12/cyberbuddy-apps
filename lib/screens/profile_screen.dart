import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import '../services/auth_service.dart';
import '../widgets/info_card.dart';
import 'app_entry_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmReset(BuildContext context) async {
    final cubit = context.read<AppCubit>();

    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'Are you sure you want to clear all saved data? This will remove your profile progress, scores, badges, and learning history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset == true) {
      await cubit.resetAllProgress();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const AppEntryScreen(),
          ),
              (route) => false,
        );
      }
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout from CyberBuddy?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await AuthService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = context.read<AppCubit>();

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.indigo,
                          child: Text(
                            state.user.name.isNotEmpty
                                ? state.user.name[0].toUpperCase()
                                : 'F',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.user.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.user.programme,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Preferred topics',
                  subtitle: 'User interests used by recommendation logic',
                  child: state.user.interests.isEmpty
                      ? const Text(
                    'No preferred topics selected yet.',
                    style: TextStyle(color: Colors.grey),
                  )
                      : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.user.interests
                        .map((interest) => Chip(label: Text(interest)))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Recommendation profile',
                  subtitle: 'Current learning data summary',
                  child: Column(
                    children: [
                      _buildRow('Learning level', state.user.level),
                      _buildRow(
                        'Completed modules',
                        '${state.completedModuleIds.length}',
                      ),
                      _buildRow(
                        'Weak topics detected',
                        '${state.weakTopics.length}',
                      ),
                      _buildRow(
                        'Pre-Test Score',
                        state.preTestScore > 0
                            ? '${state.preTestScore}%'
                            : 'Not taken yet',
                      ),
                      _buildRow(
                        'Post-Test Score',
                        state.postTestScore > 0
                            ? '${state.postTestScore}%'
                            : 'Not taken yet',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Evaluation Summary',
                  subtitle: 'Awareness and risk classification',
                  child: Column(
                    children: [
                      _buildRow(
                        'Pre-Test Awareness',
                        cubit.preTestAwarenessLevel,
                      ),
                      _buildRow(
                        'Pre-Test Risk',
                        cubit.preTestRiskLevel,
                      ),
                      _buildRow(
                        'Post-Test Awareness',
                        cubit.postTestAwarenessLevel,
                      ),
                      _buildRow(
                        'Post-Test Risk',
                        cubit.postTestRiskLevel,
                      ),
                      _buildRow(
                        'Improvement',
                        state.postTestScore > 0
                            ? '${cubit.improvementScore}%'
                            : 'Not available yet',
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          cubit.evaluationFeedback,
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Analytics summary',
                  subtitle: 'Real-time learning overview',
                  child: Column(
                    children: [
                      _buildRow(
                        'Total Completed Modules',
                        '${cubit.totalCompletedModules}',
                      ),
                      _buildRow(
                        'Total Weak Topics',
                        '${cubit.totalWeakTopics}',
                      ),
                      _buildRow(
                        'Total Correct Answers',
                        '${cubit.totalCorrectAnswers}',
                      ),
                      _buildRow(
                        'Total Wrong Answers',
                        '${cubit.totalWrongAnswers}',
                      ),
                      _buildRow(
                        'Total Quiz Answered',
                        '${cubit.totalQuizAnswered}',
                      ),
                      _buildRow(
                        'Accuracy Rate',
                        '${cubit.estimatedAccuracyRate.toStringAsFixed(0)}%',
                      ),
                      _buildRow(
                        'Strongest Topic',
                        cubit.strongestTopic,
                      ),
                      _buildRow(
                        'Weakest Topic',
                        cubit.weakestTopic,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _confirmLogout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _confirmReset(context),
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset Progress'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}