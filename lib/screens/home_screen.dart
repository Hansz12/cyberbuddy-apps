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
    final cubit = context.read<AppCubit>();

    await cubit.openModule(module);

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const ModuleDetailScreen(),
        ),
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
                  title: 'Mission Progress',
                  subtitle: 'Track your cybersecurity mission completion',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _progressHeader(
                        '$completedCount/$totalModules cyber missions completed',
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
                        'XP Level Progress',
                        '${cubit.remainingToNextLevel} XP to next level',
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: cubit.levelProgress,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                InfoCard(
                  title: 'Awareness Evaluation',
                  subtitle: 'Baseline and final cybersecurity awareness result',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Placement Test'),
                      _metricRow(
                        icon: Icons.assignment_outlined,
                        label: 'Placement Score',
                        value: '${state.preTestScore}%',
                      ),
                      _metricRow(
                        icon: Icons.psychology_outlined,
                        label: 'Initial Awareness',
                        value: cubit.preTestAwarenessLevel,
                      ),
                      _metricRow(
                        icon: Icons.security_outlined,
                        label: 'Initial Risk Level',
                        value: cubit.preTestRiskLevel,
                      ),
                      const SizedBox(height: 10),
                      _sectionLabel('Final Challenge'),
                      _metricRow(
                        icon: Icons.fact_check_outlined,
                        label: 'Post-Test Score',
                        value:
                        hasPostTest ? '${state.postTestScore}%' : 'Not taken',
                      ),
                      _metricRow(
                        icon: Icons.insights_outlined,
                        label: 'Final Awareness',
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
                                builder: (_) => BlocProvider.value(
                                  value: context.read<AppCubit>(),
                                  child: const PostTestScreen(),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.fact_check_outlined),
                          label: Text(
                            hasPostTest
                                ? 'Retake Final Challenge'
                                : 'Take Final Challenge',
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
                        'Smart Recommendations',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Cosine-based',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Personalized cyber missions based on your interests, weak topics, and learning profile.',
                  style: TextStyle(color: Colors.grey, height: 1.4),
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
                  title: 'Daily Quests',
                  subtitle: 'Complete today’s tasks to keep your streak alive',
                  child: Column(
                    children: [
                      _questItem(
                        title: 'Complete 1 cyber mission',
                        reward: '+50 XP',
                        done: state.completedModuleIds.isNotEmpty,
                      ),
                      const SizedBox(height: 10),
                      _questItem(
                        title: 'Answer at least 3 challenge questions',
                        reward: '+20 XP',
                        done: cubit.totalQuizAnswered >= 3,
                      ),
                      const SizedBox(height: 10),
                      _questItem(
                        title: 'Maintain your learning streak',
                        reward: 'Streak',
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
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('Continue Cyber Missions'),
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
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withOpacity(0.18),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cyber Defender',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${cubit.preTestAwarenessLevel} • ${state.user.level}',
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
                  label: 'XP',
                  value: '${state.points}',
                  icon: Icons.bolt_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _heroStat(
                  label: 'Rank',
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
    final similarity =
    (cubit.cosineSimilarity(cubit.userVector(), cubit.moduleVector(module)) *
        100)
        .toStringAsFixed(0);

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
                  completed ? Icons.check_circle_outline : Icons.psychology,
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
                        _smallChip('${module.points} XP'),
                        _smallChip('$similarity% match'),
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
    final lower = text.toLowerCase();
    final isCompleted = lower == 'completed';
    final isMatch = lower.contains('match');

    Color bg = Colors.indigo.shade50;
    Color fg = Colors.indigo.shade700;

    if (isCompleted) {
      bg = Colors.green.shade50;
      fg = Colors.green.shade700;
    } else if (isMatch) {
      bg = Colors.deepPurple.shade50;
      fg = Colors.deepPurple.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _questItem({
    required String title,
    required String reward,
    required bool done,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: done ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: done ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              reward,
              style: TextStyle(
                color: Colors.amber.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
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
                'Complete your profile and challenge activity to receive personalized smart recommendations.',
                style: TextStyle(height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}