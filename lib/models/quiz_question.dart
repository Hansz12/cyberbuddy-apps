class QuizQuestion {
  final String question;
  final List<String> options;
  final int answerIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  factory QuizQuestion.fromFirestore(Map<String, dynamic> data) {
    return QuizQuestion(
      question: data['question']?.toString() ?? 'No question available',
      options: (data['options'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      answerIndex: (data['answerIndex'] as num?)?.toInt() ?? 0,
    );
  }
}