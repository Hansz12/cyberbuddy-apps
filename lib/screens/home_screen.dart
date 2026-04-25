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

  Future<void> _openModule(
      BuildContext context,
      LearningModule module,
      ) async {
    await context.read<AppCubit>().openModule(module);

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ModuleDetailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = context.read<AppCubit>();
        final recommended = cubit.recommendedModules;
        final completedCount = cubit.totalCompletedModules;
        final totalModules = state.modules.length;
        final completionRate =
        totalModules == 0 ? 0.0 : completedCount / totalModules;
        final hasPostTest = state.postTestScore > 0;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroCard(state, cubit),
                const SizedBox(height: 16),

                InfoCard(
                  title: 'Learning Progress',
                  subtitle: 'Your module completion overview',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _progressHeader(
                        '$completedCount/$totalModules modules completed',
                        '${(completionRate * 100).toStringAsFixed(0)}%',
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: completionRate,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.indigo,
                        backgroundColor: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 18),
                      _progressHeader(
                        'Level Progress',
                        '${cubit.remainingToNextLevel} pts to next level',
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: cubit.levelProgress,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.indigo,
                        backgroundColor: Colors.grey.shade300,
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
                      _sectionLabel('Baseline Assessment'),
                      _metricRow(
                        icon: Icons.assignment_outlined,
                        label: 'Pre-Test Score',
                        value: '${state.preTestScore}%',
                      ),
                      _metricRow(
                        icon: Icons.psychology_outlined,
                        label: 'Pre-Test Awareness',
                        value: cubit.preTestAwarenessLevel,
                      ),
                      _metricRow(
                        icon: Icons.security_outlined,
                        label: 'Pre-Test Risk',
                        value: cubit.preTestRiskLevel,
                      ),
                      const SizedBox(height: 10),
                      _sectionLabel('Final Assessment'),
                      _metricRow(
                        icon: Icons.fact_check_outlined,
                        label: 'Post-Test Score',
                        value:
                        hasPostTest ? '${state.postTestScore}%' : 'Not taken',
                      ),
                      _metricRow(
                        icon: Icons.insights_outlined,
                        label: 'Post-Test Awareness',
                        value: hasPostTest
                            ? cubit.postTestAwarenessLevel
                            : 'Not available',
                      ),
                      _metricRow(
                        icon: Icons.trending_up,
                        label: 'Improvement',
                        value: hasPostTest
                            ? '${cubit.improvementScore}%'
                            : 'Not available',
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          cubit.evaluationFeedback,
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PostTestScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.fact_check_outlined),
                          label: Text(
                            hasPostTest ? 'Retake Post-Test' : 'Take Post-Test',
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Recommended for You',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${recommended.length} modules',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (recommended.isEmpty)
                  _emptyRecommendationCard()
                else
                  ...recommended.map(
                        (module) => _recommendationCard(
                      context,
                      cubit,
                      module,
                    ),
                  ),

                const SizedBox(height: 16),

                InfoCard(
                  title: 'Daily Quest',
                  subtitle: 'Complete today’s cybersecurity task',
                  child: Column(
                    children: [
                      _questItem(
                        title: 'Complete one learning module',
                        done: state.completedModuleIds.isNotEmpty,
                      ),
                      const SizedBox(height: 10),
                      _questItem(
                        title: 'Answer at least one quiz',
                        done: cubit.totalQuizAnswered > 0,
                      ),
                      const SizedBox(height: 10),
                      _questItem(
                        title: 'Maintain your streak',
                        done: state.streak > 0,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      context.read<AppCubit>().changeTab(1);
                    },
                    icon: const Icon(Icons.menu_book_outlined),
                    label: const Text('Continue Learning'),
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
        );
      },
    );
  }

  Widget _heroCard(AppState state, AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cubit.preTestAwarenessLevel,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _heroStat(
                  label: 'Points',
                  value: '${state.points}',
                  icon: Icons.star_border,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _heroStat(
                  label: 'Level',
                  value: 'Lv ${cubit.level + 1}',
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _heroStat(
                  label: 'Streak',
                  value: '${state.streak}d',
                  icon: Icons.local_fire_department_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressHeader(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.indigo.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _metricRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.indigo),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendationCard(
      BuildContext context,
      AppCubit cubit,
      LearningModule module,
      ) {
    final completed = cubit.state.completedModuleIds.contains(module.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _openModule(context, module),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: completed
                    ? Colors.green.shade50
                    : Colors.indigo.shade50,
                child: Icon(
                  completed ? Icons.check_circle_outline : module.icon,
                  color: completed ? Colors.green : Colors.indigo,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cubit.getRecommendationReason(module),
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _smallChip(module.difficulty),
                        _smallChip(module.duration),
                        _smallChip('${module.points} pts'),
                        if (completed) _smallChip('Completed'),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallChip(String text) {
    final isCompleted = text.toLowerCase() == 'completed';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isCompleted ? Colors.green.shade700 : Colors.indigo.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _questItem({
    required String title,
    required bool done,
  }) {
    return Row(
      children: [
        Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(title),
        ),
      ],
    );
  }

  Widget _emptyRecommendationCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.indigo),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Complete your profile and quiz activity to receive personalized recommendations.',
                style: TextStyle(height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}