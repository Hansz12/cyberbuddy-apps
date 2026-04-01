import 'package:flutter_bloc/flutter_bloc.dart';

import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());

  void startQuiz(List<Map<String, dynamic>> questions) {
    emit(QuizInProgress(questionIndex: 0, score: 0, questions: questions));
  }

  void answerQuestion(bool isCorrect) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      int newScore = isCorrect ? currentState.score + 1 : currentState.score;
      int nextIndex = currentState.questionIndex + 1;

      if (nextIndex < currentState.questions.length) {
        emit(QuizInProgress(
          questionIndex: nextIndex,
          score: newScore,
          questions: currentState.questions,
        ));
      } else {
        emit(QuizFinished(newScore, currentState.questions.length));
      }
    }
  }

  void reset() => emit(QuizInitial());
}
