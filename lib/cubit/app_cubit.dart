import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/dummy_data.dart';
import '../models/app_user.dart';
import '../models/learning_module.dart';
import '../models/quiz_question.dart';
import '../services/firestore_content_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  List<QuizQuestion> _currentQuiz = [];

  AppCubit()
      : super(
    AppState(
      user: const AppUser(
        name: 'User',
        programme: 'Computer Science (Mobile Computing)',
        level: 'Beginner',
        interests: [],
      ),
      modules: DummyData.modules,
      completedModuleIds: const [],
      weakTopics: const [],
      points: 0,
      streak: 0,
      currentIndex: 0,
      selectedModule: null,
      quizIndex: 0,
      selectedAnswer: null,
      quizDone: false,
      badges: DummyData.badges,
      search: '',
      hasTakenPreTest: false,
      preTestScore: 0,
      postTestScore: 0,
      isLoaded: false,
      topicCorrectAnswers: const {},
      topicWrongAnswers: const {},
      lastLearningDate: '',
    ),
  ) {
    loadFromStorage();
  }

  bool get isProfileCompleted =>
      state.user.name.trim().isNotEmpty &&
          state.user.name.trim() != 'User' &&
          state.user.interests.isNotEmpty;

  List<String> _decodeStringList(dynamic raw) {
    if (raw == null) return [];

    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }

    if (raw is String) {
      if (raw.trim().isEmpty) return [];
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        return [];
      }
    }

    return [];
  }

  Map<String, int> _decodeIntMap(dynamic raw) {
    if (raw == null) return {};

    if (raw is Map) {
      return raw.map(
            (key, value) => MapEntry(key.toString(), (value as num).toInt()),
      );
    }

    if (raw is String) {
      if (raw.trim().isEmpty) return {};
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          return decoded.map(
                (key, value) => MapEntry(key.toString(), (value as num).toInt()),
          );
        }
      } catch (_) {
        return {};
      }
    }

    return {};
  }

  String _todayString() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  bool _isYesterday(String lastDate, String today) {
    try {
      final last = DateTime.parse(lastDate);
      final current = DateTime.parse(today);
      return current.difference(last).inDays == 1;
    } catch (_) {
      return false;
    }
  }

  Future<void> saveToStorage() async {
    await StorageService.save('activeUid', FirestoreService.currentUid ?? '');
    await StorageService.save('name', state.user.name);
    await StorageService.save('programme', state.user.programme);
    await StorageService.save('level', state.user.level);
    await StorageService.save('interests', state.user.interests);
    await StorageService.save('points', state.points);
    await StorageService.save('streak', state.streak);
    await StorageService.save('completed', state.completedModuleIds);
    await StorageService.save('weak', state.weakTopics);
    await StorageService.save('hasTakenPreTest', state.hasTakenPreTest);
    await StorageService.save('preTestScore', state.preTestScore);
    await StorageService.save('postTestScore', state.postTestScore);
    await StorageService.save('topicCorrectAnswers', state.topicCorrectAnswers);
    await StorageService.save('topicWrongAnswers', state.topicWrongAnswers);
    await StorageService.save('lastLearningDate', state.lastLearningDate);
  }

  Future<void> syncProgressToCloud() async {
    await FirestoreService.saveUserProgress(
      points: state.points,
      streak: state.streak,
      completedModuleIds: state.completedModuleIds,
      weakTopics: state.weakTopics,
      hasTakenPreTest: state.hasTakenPreTest,
      preTestScore: state.preTestScore,
      postTestScore: state.postTestScore,
      topicCorrectAnswers: state.topicCorrectAnswers,
      topicWrongAnswers: state.topicWrongAnswers,
      lastLearningDate: state.lastLearningDate,
    );
  }

  Future<void> loadFromStorage() async {
    try {
      final currentUid = FirestoreService.currentUid;
      final savedUid = await StorageService.load('activeUid');

      if (currentUid != null &&
          savedUid != null &&
          savedUid.toString().isNotEmpty &&
          savedUid.toString() != currentUid) {
        await StorageService.clearAll();
      }

      final name = await StorageService.load('name') ?? 'User';
      final programme = await StorageService.load('programme') ??
          'Computer Science (Mobile Computing)';
      final level = await StorageService.load('level') ?? 'Beginner';

      final interests =
      _decodeStringList(await StorageService.load('interests'));
      final points = await StorageService.load('points') ?? 0;
      final streak = await StorageService.load('streak') ?? 0;
      final completed =
      _decodeStringList(await StorageService.load('completed'));
      final weak = _decodeStringList(await StorageService.load('weak'));
      final hasTakenPreTest =
          await StorageService.load('hasTakenPreTest') ?? false;
      final preTestScore = await StorageService.load('preTestScore') ?? 0;
      final postTestScore = await StorageService.load('postTestScore') ?? 0;
      final lastLearningDate =
          await StorageService.load('lastLearningDate') ?? '';

      final topicCorrectAnswers =
      _decodeIntMap(await StorageService.load('topicCorrectAnswers'));
      final topicWrongAnswers =
      _decodeIntMap(await StorageService.load('topicWrongAnswers'));

      emit(
        state.copyWith(
          user: state.user.copyWith(
            name: name.toString(),
            programme: programme.toString(),
            level: level.toString(),
            interests: interests,
          ),
          points: (points as num).toInt(),
          streak: (streak as num).toInt(),
          completedModuleIds: completed,
          weakTopics: weak,
          hasTakenPreTest: hasTakenPreTest == true,
          preTestScore: (preTestScore as num).toInt(),
          postTestScore: (postTestScore as num).toInt(),
          topicCorrectAnswers: topicCorrectAnswers,
          topicWrongAnswers: topicWrongAnswers,
          lastLearningDate: lastLearningDate.toString(),
          isLoaded: false,
        ),
      );

      await loadFromCloud();
      await loadModulesFromCloud();

      emit(state.copyWith(isLoaded: true));
      _refreshBadges();
    } catch (_) {
      emit(state.copyWith(isLoaded: true));
    }
  }

  Future<void> loadFromCloud() async {
    try {
      final profile = await FirestoreService.getUserProfile();
      final progress = await FirestoreService.getUserProgress();

      if (profile == null && progress == null) {
        await saveToStorage();
        return;
      }

      final merged = {...?profile, ...?progress};

      emit(
        state.copyWith(
          user: state.user.copyWith(
            name: merged['name']?.toString() ?? 'User',
            programme: merged['programme']?.toString() ??
                'Computer Science (Mobile Computing)',
            level: merged['level']?.toString() ?? 'Beginner',
            interests: _decodeStringList(merged['interests']),
          ),
          points: (merged['points'] as num?)?.toInt() ?? 0,
          streak: (merged['streak'] as num?)?.toInt() ?? 0,
          completedModuleIds: _decodeStringList(merged['completedModuleIds']),
          weakTopics: _decodeStringList(merged['weakTopics']),
          hasTakenPreTest: merged['hasTakenPreTest'] == true,
          preTestScore: (merged['preTestScore'] as num?)?.toInt() ?? 0,
          postTestScore: (merged['postTestScore'] as num?)?.toInt() ?? 0,
          topicCorrectAnswers: _decodeIntMap(merged['topicCorrectAnswers']),
          topicWrongAnswers: _decodeIntMap(merged['topicWrongAnswers']),
          lastLearningDate: merged['lastLearningDate']?.toString() ?? '',
          isLoaded: false,
        ),
      );

      await saveToStorage();
    } catch (_) {}
  }

  Future<void> loadModulesFromCloud() async {
    try {
      final modules = await FirestoreContentService.getModules();
      if (modules.isNotEmpty) {
        emit(state.copyWith(modules: modules));
      }
    } catch (_) {}
  }

  Future<void> seedModulesToCloud() async {
    await FirestoreContentService.seedInitialModules();
    await loadModulesFromCloud();
  }

  Future<void> resetAllProgress() async {
    await StorageService.clearAll();

    emit(
      AppState(
        user: const AppUser(
          name: 'User',
          programme: 'Computer Science (Mobile Computing)',
          level: 'Beginner',
          interests: [],
        ),
        modules: state.modules,
        completedModuleIds: const [],
        weakTopics: const [],
        points: 0,
        streak: 0,
        currentIndex: 0,
        selectedModule: null,
        quizIndex: 0,
        selectedAnswer: null,
        quizDone: false,
        badges: DummyData.badges
            .map((badge) => badge.copyWith(unlocked: false))
            .toList(),
        search: '',
        hasTakenPreTest: false,
        preTestScore: 0,
        postTestScore: 0,
        isLoaded: true,
        topicCorrectAnswers: const {},
        topicWrongAnswers: const {},
        lastLearningDate: '',
      ),
    );

    await saveToStorage();
    await syncProgressToCloud();
  }

  Future<void> setupProfile({
    required String name,
    required String level,
    required List<String> interests,
  }) async {
    emit(
      state.copyWith(
        user: state.user.copyWith(
          name: name,
          level: level,
          interests: interests,
        ),
      ),
    );

    await saveToStorage();

    await FirestoreService.createOrUpdateUserProfile(
      name: name,
      programme: state.user.programme,
      level: level,
      interests: interests,
    );

    await syncProgressToCloud();
    _refreshBadges();
  }

  Future<void> completePreTest(int score) async {
    emit(
      state.copyWith(
        hasTakenPreTest: true,
        preTestScore: score,
      ),
    );

    await saveToStorage();
    await syncProgressToCloud();
    _refreshBadges();
  }

  Future<void> completePostTest(int score) async {
    emit(state.copyWith(postTestScore: score));

    await saveToStorage();
    await syncProgressToCloud();
    _refreshBadges();
  }

  int get improvementScore => state.postTestScore - state.preTestScore;

  String classifyAwarenessLevel(int score) {
    if (score >= 80) return 'High Awareness';
    if (score >= 50) return 'Moderate Awareness';
    return 'Low Awareness';
  }

  String classifyRiskLevel(int score) {
    if (score >= 80) return 'Low Risk';
    if (score >= 50) return 'Moderate Risk';
    return 'High Risk';
  }

  String get preTestAwarenessLevel => classifyAwarenessLevel(state.preTestScore);

  String get postTestAwarenessLevel => state.postTestScore > 0
      ? classifyAwarenessLevel(state.postTestScore)
      : 'Not Available';

  String get preTestRiskLevel => classifyRiskLevel(state.preTestScore);

  String get postTestRiskLevel => state.postTestScore > 0
      ? classifyRiskLevel(state.postTestScore)
      : 'Not Available';

  String get evaluationFeedback {
    if (state.postTestScore == 0) {
      return 'Complete the post-test to receive your final evaluation feedback.';
    }

    if (improvementScore >= 30) {
      return 'Excellent improvement. Your cybersecurity awareness has increased significantly after using the application.';
    }

    if (improvementScore >= 10) {
      return 'Good progress. Your awareness level improved after interacting with the learning modules and quizzes.';
    }

    if (improvementScore == 0 && state.postTestScore >= 80) {
      return 'You have maintained a high level of cybersecurity awareness. Continue learning to strengthen your cybersecurity habits.';
    }

    if (improvementScore >= 0) {
      return 'Your awareness is stable, but more practice is recommended to further strengthen your cybersecurity knowledge.';
    }

    return 'Your post-test score is lower than your pre-test score. Review the recommended modules and retry the assessment.';
  }

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void updateSearch(String value) {
    emit(state.copyWith(search: value));
  }

  List<LearningModule> get filteredModules {
    final query = state.search.toLowerCase().trim();

    if (query.isEmpty) return state.modules;

    return state.modules.where((module) {
      return module.title.toLowerCase().contains(query) ||
          module.category.toLowerCase().contains(query) ||
          module.description.toLowerCase().contains(query) ||
          module.content.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> openModule(LearningModule module) async {
    final quiz = await FirestoreContentService.getQuizQuestions(module.id);
    _currentQuiz = quiz;

    emit(
      state.copyWith(
        selectedModule: module,
        quizIndex: 0,
        quizDone: false,
        clearSelectedAnswer: true,
      ),
    );
  }

  Future<void> completeLearning() async {
    final module = state.selectedModule;
    if (module == null) return;

    final completed = List<String>.from(state.completedModuleIds);
    int points = state.points;
    int streak = state.streak;
    final today = _todayString();

    if (!completed.contains(module.id)) {
      completed.add(module.id);
      points += module.points;
    }

    if (state.lastLearningDate.isEmpty) {
      streak = 1;
    } else if (state.lastLearningDate == today) {
      streak = state.streak;
    } else if (_isYesterday(state.lastLearningDate, today)) {
      streak = state.streak + 1;
    } else {
      streak = 1;
    }

    emit(
      state.copyWith(
        completedModuleIds: completed,
        points: points,
        streak: streak,
        lastLearningDate: today,
      ),
    );

    await saveToStorage();
    await syncProgressToCloud();
    _refreshBadges();
  }

  List<QuizQuestion> get currentQuiz => _currentQuiz;

  void selectAnswer(int index) {
    emit(state.copyWith(selectedAnswer: index));
  }

  Future<void> submitAnswer() async {
    if (state.selectedAnswer == null || currentQuiz.isEmpty) return;

    final question = currentQuiz[state.quizIndex];
    final isCorrect = state.selectedAnswer == question.answerIndex;
    final moduleId = state.selectedModule!.id;

    int points = state.points;
    final weak = List<String>.from(state.weakTopics);

    final updatedCorrect = Map<String, int>.from(state.topicCorrectAnswers);
    final updatedWrong = Map<String, int>.from(state.topicWrongAnswers);

    if (isCorrect) {
      points += 20;
      weak.remove(moduleId);
      updatedCorrect[moduleId] = (updatedCorrect[moduleId] ?? 0) + 1;
    } else {
      if (!weak.contains(moduleId)) {
        weak.add(moduleId);
      }
      updatedWrong[moduleId] = (updatedWrong[moduleId] ?? 0) + 1;
    }

    if (state.quizIndex < currentQuiz.length - 1) {
      emit(
        state.copyWith(
          points: points,
          weakTopics: weak,
          topicCorrectAnswers: updatedCorrect,
          topicWrongAnswers: updatedWrong,
          quizIndex: state.quizIndex + 1,
          clearSelectedAnswer: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          points: points,
          weakTopics: weak,
          topicCorrectAnswers: updatedCorrect,
          topicWrongAnswers: updatedWrong,
          quizDone: true,
        ),
      );
    }

    await saveToStorage();
    await syncProgressToCloud();
    _refreshBadges();
  }

  Future<void> finishQuizBackHome() async {
    emit(
      state.copyWith(
        currentIndex: 0,
        quizIndex: 0,
        quizDone: false,
        clearSelectedAnswer: true,
        clearSelectedModule: true,
      ),
    );

    await saveToStorage();
    await syncProgressToCloud();
  }

  int scoreModule(LearningModule module) {
    int score = 0;

    if (state.user.interests.any((interest) => module.tags.contains(interest))) {
      score += 5;
    }

    if (state.weakTopics.contains(module.id)) {
      score += 6;
    }

    if (state.user.level == module.difficulty) {
      score += 2;
    }

    if (state.user.level == 'Beginner' && module.difficulty == 'Beginner') {
      score += 1;
    }

    return score;
  }

  List<LearningModule> get recommendedModules {
    final sorted = List<LearningModule>.from(state.modules)
      ..sort((a, b) => scoreModule(b).compareTo(scoreModule(a)));
    return sorted.take(3).toList();
  }

  String getRecommendationReason(LearningModule module) {
    final reasons = <String>[];

    if (state.weakTopics.contains(module.id)) {
      reasons.add('your weak topic');
    }

    if (state.user.interests.any((interest) => module.tags.contains(interest))) {
      reasons.add('your interests');
    }

    if (state.user.level == module.difficulty ||
        (state.user.level == 'Beginner' && module.difficulty == 'Beginner')) {
      reasons.add('your learning level');
    }

    if (reasons.isEmpty) {
      return 'Recommended based on your overall learning profile.';
    }

    if (reasons.length == 1) {
      return 'Recommended because it matches ${reasons.first}.';
    }

    final last = reasons.removeLast();
    return 'Recommended because it matches ${reasons.join(', ')} and $last.';
  }

  void _refreshBadges() {
    final updated = state.badges.map((badge) {
      bool unlocked = badge.unlocked;

      switch (badge.name) {
        case 'First Step':
          unlocked = totalCompletedModules >= 1;
          break;
        case 'Cyber Explorer':
          unlocked = totalCompletedModules >= 3;
          break;
        case 'Security Master':
          unlocked =
              totalCompletedModules >= state.modules.length && state.modules.isNotEmpty;
          break;
        case 'Phishing Spotter':
          unlocked = state.completedModuleIds.contains('phishing');
          break;
        case 'Privacy Guard':
          unlocked = state.completedModuleIds.contains('privacy');
          break;
        case 'Quiz Warrior':
          unlocked = totalQuizAnswered >= 5;
          break;
        case 'Perfect Start':
          unlocked = state.preTestScore == 100 || state.postTestScore == 100;
          break;
        case 'Consistency Hero':
          unlocked = state.streak >= 3;
          break;
        case '7-Day Streak':
          unlocked = state.streak >= 7;
          break;
      }

      return badge.copyWith(unlocked: unlocked);
    }).toList();

    emit(state.copyWith(badges: updated));
  }

  int get totalCompletedModules => state.completedModuleIds.length;

  int get totalWeakTopics => state.weakTopics.length;

  int get totalCorrectAnswers =>
      state.topicCorrectAnswers.values.fold(0, (a, b) => a + b);

  int get totalWrongAnswers =>
      state.topicWrongAnswers.values.fold(0, (a, b) => a + b);

  int get totalQuizAnswered => totalCorrectAnswers + totalWrongAnswers;

  double get estimatedAccuracyRate {
    if (totalQuizAnswered == 0) return 0;
    return (totalCorrectAnswers / totalQuizAnswered) * 100;
  }

  String get weakestTopic {
    final topicIds = {
      ...state.topicCorrectAnswers.keys,
      ...state.topicWrongAnswers.keys,
    };

    if (topicIds.isEmpty) return 'No weak topic detected';

    String weakest = '';
    double lowestAccuracy = 101;

    for (final topic in topicIds) {
      final correct = state.topicCorrectAnswers[topic] ?? 0;
      final wrong = state.topicWrongAnswers[topic] ?? 0;
      final total = correct + wrong;

      if (total == 0) continue;

      final accuracy = (correct / total) * 100;

      if (accuracy < lowestAccuracy) {
        lowestAccuracy = accuracy;
        weakest = topic;
      }
    }

    if (weakest.isEmpty) return 'No weak topic detected';
    return _formatTopicName(weakest);
  }

  String get strongestTopic {
    final topicIds = {
      ...state.topicCorrectAnswers.keys,
      ...state.topicWrongAnswers.keys,
    };

    if (topicIds.isEmpty) return 'No strong topic identified yet';

    String strongest = '';
    double highestAccuracy = -1;

    for (final topic in topicIds) {
      final correct = state.topicCorrectAnswers[topic] ?? 0;
      final wrong = state.topicWrongAnswers[topic] ?? 0;
      final total = correct + wrong;

      if (total == 0) continue;

      final accuracy = (correct / total) * 100;

      if (accuracy > highestAccuracy) {
        highestAccuracy = accuracy;
        strongest = topic;
      }
    }

    if (strongest.isEmpty) return 'No strong topic identified yet';
    return _formatTopicName(strongest);
  }

  String _formatTopicName(String id) {
    switch (id) {
      case 'phishing':
        return 'Phishing';
      case 'password':
        return 'Password Security';
      case 'malware':
        return 'Malware Awareness';
      case 'privacy':
        return 'Privacy Protection';
      case 'incident':
        return 'Incident Reporting';
      default:
        return id;
    }
  }

  int get level => state.points ~/ 300;

  double get levelProgress => (state.points % 300) / 300;

  int get remainingToNextLevel => 300 - (state.points % 300);
}