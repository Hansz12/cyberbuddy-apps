import 'package:flutter/material.dart';

import '../models/learning_module.dart';

class ModuleCard extends StatelessWidget {
  final LearningModule module;
  final bool completed;
  final bool weakTopic;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.module,
    required this.completed,
    required this.weakTopic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor:
                completed ? Colors.green.shade50 : Colors.indigo.shade50,
                child: Icon(
                  completed ? Icons.check_circle_outline : module.icon,
                  color: completed ? Colors.green : Colors.indigo,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      module.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, height: 1.35),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip(module.difficulty, Colors.indigo),
                        _chip(module.duration, Colors.blueGrey),
                        _chip('${module.points} pts', Colors.deepPurple),
                        if (completed) _chip('Completed', Colors.green),
                        if (weakTopic) _chip('Weak Topic', Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}