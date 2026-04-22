import 'package:flutter/material.dart';

import '../models/badge_model.dart';
import '../models/learning_module.dart';
import '../models/quiz_question.dart';

class DummyData {
  static List<LearningModule> modules = const [
    LearningModule(
      id: 'phishing',
      title: 'Phishing Defense',
      difficulty: 'Beginner',
      category: 'Email Safety',
      duration: '8 min',
      points: 50,
      description:
      'Learn how to spot fake emails, urgent requests, and suspicious links.',
      tags: ['phishing', 'email', 'links'],
      icon: Icons.shield_outlined,
    ),
    LearningModule(
      id: 'password',
      title: 'Strong Password Habits',
      difficulty: 'Beginner',
      category: 'Account Security',
      duration: '6 min',
      points: 40,
      description:
      'Build strong unique passwords and understand why password reuse is risky.',
      tags: ['password', 'account', 'credentials'],
      icon: Icons.lock_outline,
    ),
    LearningModule(
      id: 'malware',
      title: 'Malware & Unsafe Downloads',
      difficulty: 'Intermediate',
      category: 'Device Safety',
      duration: '10 min',
      points: 60,
      description:
      'Recognize risky apps, downloads, and warning signs of malware infection.',
      tags: ['malware', 'download', 'apps'],
      icon: Icons.bug_report_outlined,
    ),
    LearningModule(
      id: 'privacy',
      title: 'Privacy on Social Media',
      difficulty: 'Beginner',
      category: 'Privacy',
      duration: '7 min',
      points: 45,
      description:
      'Reduce oversharing and protect your identity on social platforms.',
      tags: ['privacy', 'social', 'identity'],
      icon: Icons.public,
    ),
    LearningModule(
      id: 'incident',
      title: 'Basic Incident Reporting',
      difficulty: 'Intermediate',
      category: 'Response',
      duration: '5 min',
      points: 35,
      description:
      'Know what to do if a cyber incident happens and how to report it.',
      tags: ['reporting', 'incident', 'response'],
      icon: Icons.notifications_active_outlined,
    ),
  ];

  static List<BadgeModel> badges = const [
    BadgeModel(name: 'First Step', unlocked: false),
    BadgeModel(name: 'Cyber Explorer', unlocked: false),
    BadgeModel(name: 'Security Master', unlocked: false),
    BadgeModel(name: 'Phishing Spotter', unlocked: false),
    BadgeModel(name: 'Privacy Guard', unlocked: false),
    BadgeModel(name: 'Quiz Warrior', unlocked: false),
    BadgeModel(name: 'Perfect Start', unlocked: false),
    BadgeModel(name: 'Consistency Hero', unlocked: false),
    BadgeModel(name: '7-Day Streak', unlocked: false),
  ];

  static const List<Map<String, dynamic>> leaderboard = [
    {'name': 'Aiman', 'points': 1280},
    {'name': 'Farhana', 'points': 1140},
    {'name': 'Dina', 'points': 1080},
    {'name': 'Haziq', 'points': 990},
  ];

  static Map<String, List<QuizQuestion>> quizBank = const {
    'phishing': [
      QuizQuestion(
        question: 'What is a common sign of a phishing email?',
        options: [
          'A message asking for urgent action',
          'A normal class reminder',
          'A trusted saved contact',
          'A personal note from your friend',
        ],
        answerIndex: 0,
      ),
      QuizQuestion(
        question: 'What should you check before clicking a link in an email?',
        options: [
          'The font style',
          'The sender email and URL destination',
          'The email color',
          'The message length',
        ],
        answerIndex: 1,
      ),
      QuizQuestion(
        question: 'What is the safest action if you receive a suspicious email?',
        options: [
          'Reply with your password',
          'Ignore all future emails forever',
          'Report or verify the message first',
          'Click the link to check quickly',
        ],
        answerIndex: 2,
      ),
    ],
    'password': [
      QuizQuestion(
        question: 'Which option is the strongest password practice?',
        options: [
          'Using your birthday',
          'Using the same password everywhere',
          'Using a mix of letters, numbers, and symbols',
          'Using only lowercase letters',
        ],
        answerIndex: 2,
      ),
      QuizQuestion(
        question: 'Which habit is unsafe?',
        options: [
          'Using a unique password',
          'Using a password manager',
          'Reusing the same password on many accounts',
          'Changing password after suspicious activity',
        ],
        answerIndex: 2,
      ),
      QuizQuestion(
        question: 'Why should passwords be unique for each account?',
        options: [
          'To make accounts easier to guess',
          'Because one leaked password can affect multiple accounts',
          'Because apps require the same password',
          'To reduce account protection',
        ],
        answerIndex: 1,
      ),
    ],
    'malware': [
      QuizQuestion(
        question: 'What is a common source of malware?',
        options: [
          'Official app stores only',
          'Trusted system updates',
          'Unknown downloads and suspicious attachments',
          'Strong passwords',
        ],
        answerIndex: 2,
      ),
      QuizQuestion(
        question: 'What should you do before installing an app?',
        options: [
          'Ignore app permissions',
          'Check the source and reviews',
          'Turn off device security',
          'Download from random links',
        ],
        answerIndex: 1,
      ),
      QuizQuestion(
        question: 'Which action helps reduce malware risk?',
        options: [
          'Installing cracked APK files',
          'Keeping device software updated',
          'Opening every email attachment',
          'Disabling all protections',
        ],
        answerIndex: 1,
      ),
    ],
    'privacy': [
      QuizQuestion(
        question: 'What is the best way to protect social media privacy?',
        options: [
          'Share personal info publicly',
          'Review and adjust privacy settings',
          'Post your location every day',
          'Accept every stranger request',
        ],
        answerIndex: 1,
      ),
      QuizQuestion(
        question: 'Which example is risky oversharing?',
        options: [
          'Posting your full address publicly',
          'Using private account settings',
          'Reviewing followers list',
          'Removing unknown contacts',
        ],
        answerIndex: 0,
      ),
      QuizQuestion(
        question: 'Why is oversharing dangerous?',
        options: [
          'It helps attackers collect personal information',
          'It always improves account safety',
          'It blocks scams completely',
          'It hides your online identity',
        ],
        answerIndex: 0,
      ),
    ],
    'incident': [
      QuizQuestion(
        question: 'What should you do first after noticing suspicious account activity?',
        options: [
          'Ignore it',
          'Change your password immediately',
          'Post about it online first',
          'Delete all apps',
        ],
        answerIndex: 1,
      ),
      QuizQuestion(
        question: 'Why is reporting a cyber incident important?',
        options: [
          'So the issue can be handled quickly and documented',
          'To make the issue bigger',
          'To delay recovery',
          'Because nothing else matters',
        ],
        answerIndex: 0,
      ),
      QuizQuestion(
        question: 'What should you keep after a cyber incident?',
        options: [
          'Nothing',
          'Screenshots or evidence',
          'Only your opinions',
          'Just the device wallpaper',
        ],
        answerIndex: 1,
      ),
    ],
  };
}