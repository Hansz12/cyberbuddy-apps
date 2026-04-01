import 'package:flutter/material.dart';

class CyberBadge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  CyberBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

final List<CyberBadge> allAvailableBadges = [
  CyberBadge(
    id: 'first_step',
    title: 'First Step',
    description: 'Completed your first assessment.',
    icon: Icons.rocket_launch_rounded,
    color: Colors.blue,
  ),
  CyberBadge(
    id: 'phishing_scout',
    title: 'Phishing Scout',
    description: 'Perfect score in Phishing detection.',
    icon: Icons.visibility_rounded,
    color: Colors.orange,
  ),
  CyberBadge(
    id: 'password_pro',
    title: 'Password Pro',
    description: 'Mastered the art of strong keys.',
    icon: Icons.vpn_key_rounded,
    color: Colors.green,
  ),
  CyberBadge(
    id: 'cyber_hero',
    title: 'Cyber Hero',
    description: 'Reached Level 5 in awareness.',
    icon: Icons.shield_rounded,
    color: Colors.purple,
  ),
];
