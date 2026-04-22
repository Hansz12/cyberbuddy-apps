import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/learning_module.dart';
import '../models/quiz_question.dart';

class FirestoreContentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<LearningModule>> getModules() async {
    final snapshot = await _firestore.collection('modules').get();

    return snapshot.docs
        .map((doc) => LearningModule.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  static Future<List<QuizQuestion>> getQuizQuestions(String moduleId) async {
    final snapshot = await _firestore
        .collection('modules')
        .doc(moduleId)
        .collection('questions')
        .get();

    return snapshot.docs
        .map((doc) => QuizQuestion.fromFirestore(doc.data()))
        .toList();
  }

  static Future<void> seedInitialModules() async {
    final modules = [
      {
        'id': 'phishing',
        'title': 'Phishing Defense',
        'difficulty': 'Beginner',
        'category': 'Email Safety',
        'duration': '8 min',
        'points': 50,
        'description':
        'Learn how to spot fake emails, urgent requests, and suspicious links.',
        'tags': ['phishing', 'email', 'links'],
        'icon': 'shield',
        'content':
        'Phishing is a cyber attack that tricks users into revealing sensitive information such as passwords, banking details, or personal data. Always verify the sender, inspect the URL, and avoid urgent suspicious links.',
        'questions': [
          {
            'question': 'What is a common sign of a phishing email?',
            'options': [
              'A message asking for urgent action',
              'A normal class reminder',
              'A trusted saved contact',
              'A personal note from your friend',
            ],
            'answerIndex': 0,
          },
          {
            'question': 'What should you check before clicking a link in an email?',
            'options': [
              'The font style',
              'The sender email and URL destination',
              'The email color',
              'The message length',
            ],
            'answerIndex': 1,
          },
        ],
      },
      {
        'id': 'password',
        'title': 'Strong Password Habits',
        'difficulty': 'Beginner',
        'category': 'Account Security',
        'duration': '6 min',
        'points': 40,
        'description':
        'Build strong unique passwords and understand why password reuse is risky.',
        'tags': ['password', 'account', 'credentials'],
        'icon': 'lock',
        'content':
        'Strong passwords should be unique, difficult to guess, and not reused across accounts. Using password managers and two-factor authentication increases account safety.',
        'questions': [
          {
            'question': 'Which option is the strongest password practice?',
            'options': [
              'Using your birthday',
              'Using the same password everywhere',
              'Using a mix of letters, numbers, and symbols',
              'Using only lowercase letters',
            ],
            'answerIndex': 2,
          },
          {
            'question': 'Which habit is unsafe?',
            'options': [
              'Using a unique password',
              'Using a password manager',
              'Reusing the same password on many accounts',
              'Changing password after suspicious activity',
            ],
            'answerIndex': 2,
          },
        ],
      },
      {
        'id': 'malware',
        'title': 'Malware & Unsafe Downloads',
        'difficulty': 'Intermediate',
        'category': 'Device Safety',
        'duration': '10 min',
        'points': 60,
        'description':
        'Recognize risky apps, downloads, and warning signs of malware infection.',
        'tags': ['malware', 'download', 'apps'],
        'icon': 'bug',
        'content':
        'Malware is harmful software that can steal data, damage files, or compromise devices. Avoid suspicious downloads, install apps from trusted sources, and keep software updated.',
        'questions': [
          {
            'question': 'What is a common source of malware?',
            'options': [
              'Official app stores only',
              'Trusted system updates',
              'Unknown downloads and suspicious attachments',
              'Strong passwords',
            ],
            'answerIndex': 2,
          },
          {
            'question': 'Which action helps reduce malware risk?',
            'options': [
              'Installing cracked APK files',
              'Keeping device software updated',
              'Opening every email attachment',
              'Disabling all protections',
            ],
            'answerIndex': 1,
          },
        ],
      },
      {
        'id': 'privacy',
        'title': 'Privacy on Social Media',
        'difficulty': 'Beginner',
        'category': 'Privacy',
        'duration': '7 min',
        'points': 45,
        'description':
        'Reduce oversharing and protect your identity on social platforms.',
        'tags': ['privacy', 'social', 'identity'],
        'icon': 'public',
        'content':
        'Oversharing personal details online can expose users to scams, identity theft, and targeted attacks. Review privacy settings and limit sensitive public information.',
        'questions': [
          {
            'question': 'What is the best way to protect social media privacy?',
            'options': [
              'Share personal info publicly',
              'Review and adjust privacy settings',
              'Post your location every day',
              'Accept every stranger request',
            ],
            'answerIndex': 1,
          },
          {
            'question': 'Which example is risky oversharing?',
            'options': [
              'Posting your full address publicly',
              'Using private account settings',
              'Reviewing followers list',
              'Removing unknown contacts',
            ],
            'answerIndex': 0,
          },
        ],
      },
      {
        'id': 'incident',
        'title': 'Basic Incident Reporting',
        'difficulty': 'Intermediate',
        'category': 'Response',
        'duration': '5 min',
        'points': 35,
        'description':
        'Know what to do if a cyber incident happens and how to report it.',
        'tags': ['reporting', 'incident', 'response'],
        'icon': 'incident',
        'content':
        'If a cyber incident occurs, change your password, keep evidence, and report the incident promptly. Fast response reduces damage and helps recovery.',
        'questions': [
          {
            'question': 'What should you do first after noticing suspicious account activity?',
            'options': [
              'Ignore it',
              'Change your password immediately',
              'Post about it online first',
              'Delete all apps',
            ],
            'answerIndex': 1,
          },
          {
            'question': 'Why is reporting a cyber incident important?',
            'options': [
              'So the issue can be handled quickly and documented',
              'To make the issue bigger',
              'To delay recovery',
              'Because nothing else matters',
            ],
            'answerIndex': 0,
          },
        ],
      },
    ];

    for (final module in modules) {
      final moduleId = module['id'] as String;
      final moduleData = Map<String, dynamic>.from(module)..remove('questions');
      await _firestore.collection('modules').doc(moduleId).set(moduleData);

      final questions = module['questions'] as List<dynamic>;
      for (int i = 0; i < questions.length; i++) {
        await _firestore
            .collection('modules')
            .doc(moduleId)
            .collection('questions')
            .doc('q${i + 1}')
            .set(Map<String, dynamic>.from(questions[i]));
      }
    }
  }
}