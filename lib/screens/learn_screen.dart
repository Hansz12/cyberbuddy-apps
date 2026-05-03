import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import '../widgets/module_card.dart';
import 'module_detail_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = context.read<AppCubit>();
        final modules = cubit.filteredModules;

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: cubit.loadModulesFromCloud,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Cyber Missions',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Complete cybersecurity missions, unlock XP, and take challenge quizzes.',
                  style: TextStyle(color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 16),

                TextField(
                  onChanged: cubit.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search cyber missions...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        title: 'Missions Done',
                        value:
                        '${cubit.totalCompletedModules}/${state.modules.length}',
                        icon: Icons.flag_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        title: 'Weak Topics',
                        value: '${cubit.totalWeakTopics}',
                        icon: Icons.warning_amber_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (modules.isEmpty)
                  _emptyState()
                else
                  ...modules.map(
                        (module) => ModuleCard(
                      module: module,
                      completed: state.completedModuleIds.contains(module.id),
                      weakTopic: state.weakTopics.contains(module.id),
                      onTap: () async {
                        final appCubit = context.read<AppCubit>();
                        await appCubit.openModule(module);

                        if (!context.mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: appCubit,
                              child: const ModuleDetailScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo.shade50,
              child: Icon(icon, color: Colors.indigo),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 42, color: Colors.indigo),
            SizedBox(height: 12),
            Text(
              'No cyber missions found',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            SizedBox(height: 8),
            Text(
              'Try another keyword or pull down to refresh missions from Firestore.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}