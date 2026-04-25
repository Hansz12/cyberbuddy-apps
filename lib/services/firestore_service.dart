import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get currentUid => _auth.currentUser?.uid;

  static Future<void> createOrUpdateUserProfile({
    required String name,
    required String programme,
    required String level,
    required List<String> interests,
  }) async {
    final uid = currentUid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'programme': programme,
      'level': level,
      'interests': interests,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final uid = currentUid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  static Future<void> saveUserProgress({
    required int points,
    required int streak,
    required List<String> completedModuleIds,
    required List<String> weakTopics,
    required bool hasTakenPreTest,
    required int preTestScore,
    required int postTestScore,
    required Map<String, int> topicCorrectAnswers,
    required Map<String, int> topicWrongAnswers,
    required String lastLearningDate,
  }) async {
    final uid = currentUid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'points': points,
      'streak': streak,
      'completedModuleIds': completedModuleIds,
      'weakTopics': weakTopics,
      'hasTakenPreTest': hasTakenPreTest,
      'preTestScore': preTestScore,
      'postTestScore': postTestScore,
      'topicCorrectAnswers': topicCorrectAnswers,
      'topicWrongAnswers': topicWrongAnswers,
      'lastLearningDate': lastLearningDate,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getUserProgress() async {
    final uid = currentUid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  static Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final snapshot = await _firestore
        .collection('users')
        .orderBy('points', descending: true)
        .limit(20)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return {
        'uid': doc.id,
        'name': data['name']?.toString() ?? 'Unknown User',
        'points': (data['points'] as num?)?.toInt() ?? 0,
        'streak': (data['streak'] as num?)?.toInt() ?? 0,
        'level': data['level']?.toString() ?? 'Beginner',
      };
    }).toList();
  }
}