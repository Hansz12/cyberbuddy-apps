import 'package:equatable/equatable.dart';

abstract class QuizState extends Equatable {
  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {}

class QuizInProgress extends QuizState {
  final int questionIndex;
  final int score;
  final List<Map<String, dynamic>> questions;

  QuizInProgress({required this.questionIndex, required this.score, required this.questions});

  @override
  List<Object> get props => [questionIndex, score, questions];
}

class QuizFinished extends QuizState {
  final int finalScore;
  final int totalQuestions;

  QuizFinished(this.finalScore, this.totalQuestions);

  @override
  List<Object> get props => [finalScore, totalQuestions];
}