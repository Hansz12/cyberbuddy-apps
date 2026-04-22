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

  @override
  void initState() {
    super.initState();
    _tipsFuture = ApiService.fetchSecurityTips();
  }

  Future<void> _refreshTips() async {
    setState(() {
      _tipsFuture = ApiService.fetchSecurityTips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshTips,
        child: FutureBuilder<List<SecurityTip>>(
          future: _tipsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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

            if (tips.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  _TipsEmptyState(
                    icon: Icons.lightbulb_outline,
                    title: 'No tips available',
                    message:
                    'No cybersecurity tips are available at the moment.',
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Live Security Tips',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'These tips simulate external content integration for cybersecurity awareness updates.',
                  style: TextStyle(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ...tips.map(
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