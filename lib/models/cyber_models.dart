class CyberModule {
  final String id;
  final String title;
  final String tag; // e.g., 'phishing', 'passwords'
  final String difficulty;

  CyberModule({required this.id, required this.title, required this.tag, required this.difficulty});
}

class UserProfile {
  final int points;
  final int level;
  final List<String> weaknesses; // Tags from failed quizzes
  final List<String> badges;

  UserProfile({required this.points, required this.level, required this.weaknesses, required this.badges});
}