import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/profile_cubit.dart';
import '../data/module_data.dart';
import '../data/rewards_screen.dart';
import 'module_content_screen.dart';
import 'quiz_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          // Content-Based Recommendation Logic: Filter modules based on user weaknesses
          final recommended = allCyberModules
              .where((m) => state.weaknesses.contains(m.tag))
              .toList();
          final otherModules = allCyberModules
              .where((m) => !state.weaknesses.contains(m.tag))
              .toList();

          return CustomScrollView(
            slivers: [
              // 1. Premium Visual Header (Gamification & Stats)
              SliverAppBar(
                expandedHeight: 240.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF3F51B5),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.emoji_events_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RewardsScreen(),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "CyberBuddy",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStatCircle(
                                "Level",
                                state.level.toString(),
                                Icons.trending_up,
                              ),
                              const SizedBox(width: 48),
                              _buildStatCircle(
                                "XP Points",
                                state.points.toString(),
                                Icons.bolt,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Main Content Sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section A: Adaptive Recommendations (The FYP Logic)
                      if (recommended.isNotEmpty) ...[
                        _buildSectionHeader("Priority Missions", isAlert: true),
                        const SizedBox(height: 16),
                        ...recommended.map(
                          (m) =>
                              _buildModuleCard(context, m, isRecommended: true),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // Section B: Standard Learning Path
                      _buildSectionHeader("Learning Path"),
                      const SizedBox(height: 16),
                      if (otherModules.isEmpty && recommended.isEmpty)
                        const Center(child: Text("No modules available."))
                      else
                        ...otherModules.map(
                          (m) => _buildModuleCard(context, m),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuizScreen()),
        ),
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text("Start Daily Mission"),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  Widget _buildStatCircle(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Icon(icon, color: Colors.amber, size: 30),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool isAlert = false}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        if (isAlert) ...[
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "ADAPTIVE",
              style: TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    CyberModule m, {
    bool isRecommended = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: isRecommended
            ? Border.all(color: Colors.red.withOpacity(0.2), width: 1.5)
            : Border.all(color: Colors.transparent, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleContentScreen(module: m),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isRecommended
                        ? Colors.red.withOpacity(0.1)
                        : const Color(0xFF3F51B5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isRecommended
                        ? Icons.priority_high_rounded
                        : Icons.auto_stories_rounded,
                    color: isRecommended ? Colors.red : const Color(0xFF3F51B5),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFC1C4D6),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
