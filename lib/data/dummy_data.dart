import '../models/badge_model.dart';
import '../models/learning_module.dart';
import '../models/quiz_question.dart';

class DummyData {
  static List<LearningModule> modules = const [
    LearningModule(
      id: 'phishing',
      title: 'Phishing Awareness',
      difficulty: 'Beginner',
      category: 'Email Security',
      duration: '8 min',
      points: 50,
      description: 'Learn how to identify phishing attacks.',
      content:
      'Phishing is a cyber attack where attackers trick users into revealing sensitive information such as passwords, banking details, or personal data.',
      tags: ['phishing', 'email', 'scam'],
    ),
    LearningModule(
      id: 'password',
      title: 'Strong Password Security',
      difficulty: 'Beginner',
      category: 'Account Security',
      duration: '6 min',
      points: 40,
      description: 'Learn how to create and manage strong passwords.',
      content:
      'Strong passwords reduce the risk of unauthorized access. Use a unique password for each account and avoid using personal details.',
      tags: ['password', 'account', 'credentials'],
    ),
    LearningModule(
      id: 'malware',
      title: 'Malware and Unsafe Downloads',
      difficulty: 'Intermediate',
      category: 'Device Safety',
      duration: '10 min',
      points: 60,
      description: 'Understand malware risks from apps and downloads.',
      content:
      'Malware is malicious software that can steal information, damage devices, or spy on users. Avoid downloading apps from unknown sources.',
      tags: ['malware', 'app', 'download'],
    ),
    LearningModule(
      id: 'privacy',
      title: 'Privacy on Social Media',
      difficulty: 'Beginner',
      category: 'Privacy',
      duration: '7 min',
      points: 45,
      description: 'Learn how to protect personal information online.',
      content:
      'Social media privacy is important because oversharing personal data can expose users to scams, identity theft, and stalking.',
      tags: ['privacy', 'social', 'identity'],
    ),
    LearningModule(
      id: 'incident',
      title: 'Incident Reporting Basics',
      difficulty: 'Intermediate',
      category: 'Cyber Response',
      duration: '5 min',
      points: 35,
      description: 'Learn what to do when a cyber incident happens.',
      content:
      'Cyber incidents such as hacked accounts, suspicious logins, or data leaks should be handled quickly. Report the issue immediately.',
      tags: ['incident', 'reporting', 'response'],
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
        question: 'What is a phishing email?',
        options: [
          'A safe email',
          'An email asking for personal information',
          'A company newsletter',
          'A normal reminder',
        ],
        answerIndex: 1,
      ),
    ],
    'password': [
      QuizQuestion(
        question: 'Which password is strongest?',
        options: ['123456', 'password', 'MyName2002', 'T!mE#84xP'],
        answerIndex: 3,
      ),
    ],
    'malware': [
      QuizQuestion(
        question: 'What is malware?',
        options: ['A game app', 'Harmful software', 'Cloud storage', 'Safe email'],
        answerIndex: 1,
      ),
    ],
    'privacy': [
      QuizQuestion(
        question: 'Why is oversharing risky?',
        options: [
          'It improves privacy',
          'It helps attackers collect personal data',
          'It blocks scams',
          'It hides identity',
        ],
        answerIndex: 1,
      ),
    ],
    'incident': [
      QuizQuestion(
        question: 'What should you do first after account compromise?',
        options: ['Ignore it', 'Change password immediately', 'Post online', 'Delete browser'],
        answerIndex: 1,
      ),
    ],
  };
}