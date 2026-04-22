import 'package:flutter/material.dart';

class LearningModule {
  final String id;
  final String title;
  final String difficulty;
  final String category;
  final String duration;
  final int points;
  final String description;
  final List<String> tags;
  final IconData icon;
  final String? content;

  const LearningModule({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.category,
    required this.duration,
    required this.points,
    required this.description,
    required this.tags,
    required this.icon,
    this.content,
  });

  factory LearningModule.fromFirestore(
      String id,
      Map<String, dynamic> data,
      ) {
    return LearningModule(
      id: id,
      title: data['title']?.toString() ?? 'Untitled Module',
      difficulty: data['difficulty']?.toString() ?? 'Beginner',
      category: data['category']?.toString() ?? 'General',
      duration: data['duration']?.toString() ?? '5 min',
      points: (data['points'] as num?)?.toInt() ?? 0,
      description: data['description']?.toString() ?? '',
      tags: (data['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      icon: _mapIcon(data['icon']?.toString()),
      content: data['content']?.toString(),
    );
  }

  static IconData _mapIcon(String? iconName) {
    switch (iconName) {
      case 'shield':
        return Icons.shield_outlined;
      case 'lock':
        return Icons.lock_outline;
      case 'bug':
        return Icons.bug_report_outlined;
      case 'public':
        return Icons.public;
      case 'incident':
        return Icons.notifications_active_outlined;
      default:
        return Icons.menu_book_outlined;
    }
  }
}