import 'package:equatable/equatable.dart';

class QuizQuestion extends Equatable {
  final String question;
  final List<String> options;
  final int answerIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  @override
  List<Object?> get props => [question, options, answerIndex];
}