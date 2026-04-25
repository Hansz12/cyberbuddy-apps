import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LearningModule extends Equatable {
  final String id;
  final String title;
  final String difficulty;
  final String category;
  final String duration;
  final int points;
  final String description;
  final String content;
  final List<String> tags;

  const LearningModule({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.category,
    required this.duration,
    required this.points,
    required this.description,
    required this.content,
    required this.tags,
  });

  IconData get icon {
    switch (id) {
      case 'phishing':
        return Icons.phishing_outlined;
      case 'password':
        return Icons.lock_outline;
      case 'malware':
        return Icons.bug_report_outlined;
      case 'privacy':
        return Icons.privacy_tip_outlined;
      case 'incident':
        return Icons.report_problem_outlined;
      default:
        return Icons.security_outlined;
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    difficulty,
    category,
    duration,
    points,
    description,
    content,
    tags,
  ];
}