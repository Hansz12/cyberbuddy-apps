import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import '../services/firestore_service.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  late Future<List<Map<String, dynamic>>> _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = FirestoreService.getLeaderboard();
  }

  Future<void> _refreshLeaderboard() async {
    setState(() {
      _leaderboardFuture = FirestoreService.getLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final unlockedCount =
            state.badges.where((badge) => badge.unlocked).length;

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshLeaderboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _metricCard(
                          'Total Points',
                          '${state.points}',
                          Icons.emoji_events_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _metricCard(
                          'Badges',
                          '$unlockedCount',
                          Icons.workspace_premium_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Badge Collection',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.badges.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.3,
                            ),
                            itemBuilder: (context, index) {
                              final badge = state.badges[index];

                              return Container(
                                decoration: BoxDecoration(
                                  color: badge.unlocked
                                      ? Colors.amber.shade50
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: badge.unlocked
                                        ? Colors.amber.shade200
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: badge.unlocked
                                          ? Colors.amber
                                          : Colors.grey,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        badge.name,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _leaderboardFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return _emptyLeaderboard(
                              title: 'Unable to load leaderboard',
                              message:
                              'Please check your internet connection and try again.',
                            );
                          }

                          final leaderboard = snapshot.data ?? [];

                          if (leaderboard.isEmpty) {
                            return _emptyLeaderboard(
                              title: 'No leaderboard data yet',
                              message:
                              'Complete learning modules and quizzes to appear on the leaderboard.',
                            );
                          }

                          final currentUid = FirestoreService.currentUid;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Live Leaderboard',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _refreshLeaderboard,
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Ranking is based on total points stored in Firestore.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...leaderboard.asMap().entries.map((entry) {
                                final index = entry.key;
                                final row = entry.value;
                                final isUser = row['uid'] == currentUid;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? Colors.blue.shade50
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isUser
                                          ? Colors.blue.shade300
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: isUser
                                            ? Colors.indigo
                                            : Colors.grey.shade300,
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: isUser
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isUser
                                                  ? '${row['name']} (You)'
                                                  : row['name'].toString(),
                                              style: TextStyle(
                                                fontWeight: isUser
                                                    ? FontWeight.bold
                                                    : FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${row['level']} • ${row['streak']} day streak',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${row['points']} pts',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _metricCard(String label, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.indigo),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyLeaderboard({
    required String title,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Icon(
            Icons.leaderboard_outlined,
            color: Colors.indigo,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}