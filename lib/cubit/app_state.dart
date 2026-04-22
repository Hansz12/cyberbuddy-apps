import 'package:equatable/equatable.dart';

import '../models/app_user.dart';
import '../models/badge_model.dart';
import '../models/learning_module.dart';

class AppState extends Equatable {
  final AppUser user;
  final List<LearningModule> modules;
  final List<String> completedModuleIds;
  final List<String> weakTopics;
  final int points;
  final int streak;
  final int currentIndex;

  final LearningModule? selectedModule;
  final int quizIndex;
  final int? selectedAnswer;
  final bool quizDone;

  final List<BadgeModel> badges;
  final String search;

  final bool hasTakenPreTest;
  final int preTestScore;
  final int postTestScore;
  final bool isLoaded;

  final Map<String, int> topicCorrectAnswers;
  final Map<String, int> topicWrongAnswers;

  final String lastLearningDate;

  const AppState({
    required this.user,
    required this.modules,
    required this.completedModuleIds,
    required this.weakTopics,
    required this.points,
    required this.streak,
    required this.currentIndex,
    required this.selectedModule,
    required this.quizIndex,
    required this.selectedAnswer,
    required this.quizDone,
    required this.badges,
    required this.search,
    required this.hasTakenPreTest,
    required this.preTestScore,
    required this.postTestScore,
    required this.isLoaded,
    required this.topicCorrectAnswers,
    required this.topicWrongAnswers,
    required this.lastLearningDate,
  });

  AppState copyWith({
    AppUser? user,
    List<LearningModule>? modules,
    List<String>? completedModuleIds,
    List<String>? weakTopics,
    int? points,
    int? streak,
    int? currentIndex,
    LearningModule? selectedModule,
    int? quizIndex,
    int? selectedAnswer,
    bool? quizDone,
    List<BadgeModel>? badges,
    String? search,
    bool? hasTakenPreTest,
    int? preTestScore,
    int? postTestScore,
    bool? isLoaded,
    Map<String, int>? topicCorrectAnswers,
    Map<String, int>? topicWrongAnswers,
    String? lastLearningDate,
    bool clearSelectedModule = false,
    bool clearSelectedAnswer = false,
  }) {
    return AppState(
      user: user ?? this.user,
      modules: modules ?? this.modules,
      completedModuleIds: completedModuleIds ?? this.completedModuleIds,
      weakTopics: weakTopics ?? this.weakTopics,
      points: points ?? this.points,
      streak: streak ?? this.streak,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedModule:
      clearSelectedModule ? null : (selectedModule ?? this.selectedModule),
      quizIndex: quizIndex ?? this.quizIndex,
      selectedAnswer:
      clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      quizDone: quizDone ?? this.quizDone,
      badges: badges ?? this.badges,
      search: search ?? this.search,
      hasTakenPreTest: hasTakenPreTest ?? this.hasTakenPreTest,
      preTestScore: preTestScore ?? this.preTestScore,
      postTestScore: postTestScore ?? this.postTestScore,
      isLoaded: isLoaded ?? this.isLoaded,
      topicCorrectAnswers: topicCorrectAnswers ?? this.topicCorrectAnswers,
      topicWrongAnswers: topicWrongAnswers ?? this.topicWrongAnswers,
      lastLearningDate: lastLearningDate ?? this.lastLearningDate,
    );
  }

  @override
  List<Object?> get props => [
    user,
    modules,
    completedModuleIds,
    weakTopics,
    points,
    streak,
    currentIndex,
    selectedModule,
    quizIndex,
    selectedAnswer,
    quizDone,
    badges,
    search,
    hasTakenPreTest,
    preTestScore,
    postTestScore,
    isLoaded,
    topicCorrectAnswers,
    topicWrongAnswers,
    lastLearningDate,
  ];
}