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
  final List<String> tags;
  final IconData icon;

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
  });

  @override
  List<Object?> get props => [
    id,
    title,
    difficulty,
    category,
    duration,
    points,
    description,
    tags,
    icon,
  ];
}