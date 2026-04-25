import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/learning_module.dart';
import '../models/quiz_question.dart';

class FirestoreContentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<LearningModule>> getModules() async {
    final snapshot = await _firestore.collection('modules').get();

    final modules = snapshot.docs.map((doc) {
      final data = doc.data();

      return LearningModule(
        id: doc.id,
        title: (data['title'] ?? '').toString(),
        category: (data['category'] ?? '').toString(),
        difficulty: (data['difficulty'] ?? '').toString(),
        duration: (data['duration'] ?? '').toString(),
        points: (data['points'] ?? 0) is int
            ? data['points'] as int
            : int.tryParse(data['points'].toString()) ?? 0,
        description: (data['description'] ?? '').toString(),
        content: (data['content'] ?? '').toString(),
        tags: List<String>.from(data['tags'] ?? const []),
      );
    }).toList();

    modules.sort((a, b) => a.title.compareTo(b.title));
    return modules;
  }

  static Future<List<QuizQuestion>> getQuizQuestions(String moduleId) async {
    final snapshot = await _firestore
        .collection('modules')
        .doc(moduleId)
        .collection('questions')
        .get();

    final questions = snapshot.docs.map((doc) {
      final data = doc.data();

      return QuizQuestion(
        question: (data['question'] ?? '').toString(),
        options: List<String>.from(data['options'] ?? const []),
        answerIndex: (data['answerIndex'] ?? 0) is int
            ? data['answerIndex'] as int
            : int.tryParse(data['answerIndex'].toString()) ?? 0,
      );
    }).toList();

    return questions;
  }

  static Future<void> seedInitialModules() async {
    final existing = await _firestore.collection('modules').limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final seedModules = [
      {
        'id': 'phishing',
        'title': 'Phishing Awareness',
        'category': 'Email Security',
        'difficulty': 'Beginner',
        'duration': '8 min',
        'points': 50,
        'description': 'Learn how to identify phishing attacks',
        'content':
        'Phishing is a cyber attack where attackers trick users into revealing sensitive information such as passwords, banking details, or personal data. Always verify the sender, inspect suspicious links, and avoid entering credentials on unknown websites.',
        'tags': ['phishing', 'email', 'scam'],
        'questions': [
          {
            'question': 'What is a phishing email?',
            'options': [
              'A safe email',
              'An email asking for personal information',
              'A company newsletter',
              'A normal reminder'
            ],
            'answerIndex': 1,
          },
          {
            'question': 'What should you do before clicking a suspicious link?',
            'options': [
              'Click immediately',
              'Verify sender and URL',
              'Forward it to friends',
              'Ignore all warnings'
            ],
            'answerIndex': 1,
          },
        ],
      },
      {
        'id': 'password',
        'title': 'Strong Password Security',
        'category': 'Account Security',
        'difficulty': 'Beginner',
        'duration': '6 min',
        'points': 40,
        'description': 'Learn how to create and manage strong passwords',
        'content':
        'Strong passwords reduce the risk of unauthorized access. Use a unique password for each account, combine letters, numbers, and symbols, and avoid personal details. Password managers can help store credentials securely.',
        'tags': ['password', 'account', 'credentials'],
        'questions': [
          {
            'question': 'Which password is strongest?',
            'options': ['123456', 'password', 'MyName2002', 'T!mE#84xP'],
            'answerIndex': 3,
          },
          {
            'question': 'Why is password reuse dangerous?',
            'options': [
              'It makes login slower',
              'One leaked password can affect many accounts',
              'It improves security',
              'Apps require the same password'
            ],
            'answerIndex': 1,
          },
        ],
      },
    ];

    for (final module in seedModules) {
      final moduleId = module['id'] as String;
      final questions =
      List<Map<String, dynamic>>.from(module['questions'] as List);

      await _firestore.collection('modules').doc(moduleId).set({
        'title': module['title'],
        'category': module['category'],
        'difficulty': module['difficulty'],
        'duration': module['duration'],
        'points': module['points'],
        'description': module['description'],
        'content': module['content'],
        'tags': module['tags'],
      });

      for (int i = 0; i < questions.length; i++) {
        await _firestore
            .collection('modules')
            .doc(moduleId)
            .collection('questions')
            .doc('${moduleId}_q${i + 1}')
            .set(questions[i]);
      }
    }
  }
}