import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import '../models/learning_module.dart';
import '../widgets/info_card.dart';
import 'module_detail_screen.dart';
import 'posttest_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = context.read<AppCubit>();
        final recommended = cubit.recommendedModules;
        final hasPostTest = state.postTestScore > 0;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatBox('Points', '${state.points}'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatBox('Level', '${cubit.level}'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatBox('Streak', '${state.streak}d'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Weekly progress',
                  subtitle: 'Keep your awareness growing',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: cubit.levelProgress,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${cubit.remainingToNextLevel} points to next level',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Learning Evaluation',
                  subtitle: 'Pre-test and post-test performance',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pre-Test Score: ${state.preTestScore}%'),
                      const SizedBox(height: 6),
                      Text('Pre-Test Awareness: ${cubit.preTestAwarenessLevel}'),
                      const SizedBox(height: 6),
                      Text('Pre-Test Risk: ${cubit.preTestRiskLevel}'),
                      const SizedBox(height: 10),
                      Text(
                        hasPostTest
                            ? 'Post-Test Score: ${state.postTestScore}%'
                            : 'Post-Test Score: Not taken yet',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasPostTest
                            ? 'Post-Test Awareness: ${cubit.postTestAwarenessLevel}'
                            : 'Post-Test Awareness: Not available yet',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasPostTest
                            ? 'Post-Test Risk: ${cubit.postTestRiskLevel}'
                            : 'Post-Test Risk: Not available yet',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasPostTest
                            ? 'Improvement: ${cubit.improvementScore}%'
                            : 'Improvement: Not available yet',
                      ),
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
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PostTestScreen(),
                              ),
                            );
                          },
                          child: Text(
                            hasPostTest ? 'Retake Post-Test' : 'Take Post-Test',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recommended for you',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (recommended.isEmpty)
                  _buildEmptyStateCard(
                    icon: Icons.lightbulb_outline,
                    title: 'No recommendations yet',
                    message:
                    'Complete your profile and interact with learning modules to receive personalized recommendations.',
                  )
                else
                  ...recommended.map(
                        (module) => _recommendedTile(context, cubit, module),
                  ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Daily quest',
                  subtitle: 'Finish 1 module + 1 quiz',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            state.completedModuleIds.isNotEmpty
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: state.completedModuleIds.isNotEmpty
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          const Text('Complete a lesson'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            state.postTestScore >= 80
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: state.postTestScore >= 80
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          const Text('Reach 80% post-test score'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendedTile(
      BuildContext context,
      AppCubit cubit,
      LearningModule module,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: Icon(module.icon, color: Colors.indigo),
        ),
        title: Text(module.title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            cubit.getRecommendationReason(module),
            style: const TextStyle(height: 1.4),
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.read<AppCubit>().openModule(module);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ModuleDetailScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyStateCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.indigo, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.grey, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}