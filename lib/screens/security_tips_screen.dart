import 'package:flutter/material.dart';

import '../models/security_tip.dart';
import '../services/api_service.dart';

class SecurityTipsScreen extends StatefulWidget {
  const SecurityTipsScreen({super.key});

  @override
  State<SecurityTipsScreen> createState() => _SecurityTipsScreenState();
}

class _SecurityTipsScreenState extends State<SecurityTipsScreen> {
  late Future<List<SecurityTip>> _tipsFuture;
  String selectedCategory = 'All';

  final List<String> categories = const [
    'All',
    'Phishing',
    'Password',
    'Privacy',
    'Malware',
    'Incident',
    'Live Vulnerabilities',
  ];

  @override
  void initState() {
    super.initState();
    _tipsFuture = ApiService.fetchSecurityTips();
  }

  Future<void> _refreshTips() async {
    setState(() {
      _tipsFuture = ApiService.fetchSecurityTips();
    });
    await _tipsFuture;
  }

  List<SecurityTip> _filterTips(List<SecurityTip> tips) {
    if (selectedCategory == 'All') return tips;
    return tips.where((tip) => tip.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshTips,
        child: FutureBuilder<List<SecurityTip>>(
          future: _tipsFuture,
          builder: (context, snapshot) {
            final isLoading = snapshot.connectionState == ConnectionState.waiting;

            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  _TipsEmptyState(
                    icon: Icons.error_outline,
                    title: 'Unable to load tips',
                    message:
                    'Something went wrong while retrieving cybersecurity tips. Please try again.',
                  ),
                ],
              );
            }

            final tips = snapshot.data ?? [];
            final filteredTips = _filterTips(tips);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Live Security Tips',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _refreshTips,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'CyberBuddy combines awareness tips with live cybersecurity updates from an external source.',
                  style: TextStyle(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final selected = selectedCategory == category;

                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (filteredTips.isEmpty)
                  const _TipsEmptyState(
                    icon: Icons.filter_alt_off_outlined,
                    title: 'No tips found',
                    message:
                    'No tips match the selected category. Try another filter or refresh the feed.',
                  )
                else
                  ...filteredTips.map(
                        (tip) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Chip(
                                  label: Text(tip.category),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Chip(
                                  label: Text(tip.source),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              tip.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tip.description,
                              style: const TextStyle(
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TipsEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _TipsEmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 42, color: Colors.indigo),
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
              style: const TextStyle(
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}