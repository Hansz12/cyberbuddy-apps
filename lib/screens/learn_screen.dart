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
        final hasSearch = state.search.trim().isNotEmpty;

        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: cubit.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search module, topic, or category',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: modules.isEmpty
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildEmptyState(
                    icon: Icons.menu_book_outlined,
                    title: hasSearch
                        ? 'No module found'
                        : 'No learning modules available',
                    message: hasSearch
                        ? 'Try a different keyword or clear your search to view all modules.'
                        : 'Modules will appear here once learning content is available.',
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    final completed =
                    state.completedModuleIds.contains(module.id);

                    return ModuleCard(
                      module: module,
                      completed: completed,
                      onTap: () {
                        cubit.openModule(module);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const ModuleDetailScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 44, color: Colors.indigo),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}