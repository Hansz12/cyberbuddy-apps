import 'package:flutter_bloc/flutter_bloc.dart';

// The state stores user data for the recommendation engine
class ProfileState {
  final int points;
  final int level;
  final List<String> weaknesses; // Tags like 'phishing'
  ProfileState({required this.points, required this.level, required this.weaknesses});
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState(points: 0, level: 1, weaknesses: []));

  /// Called once when the app starts. Wire in Firestore (or remote API) when you have a user id.
  Future<void> loadData() async {
    // Example later: final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // if (doc.exists) emit(ProfileState(...));
  }

  // Logic to update points and identify learning gaps
  void addProgress(int gainedPoints, String? categoryFailed) {
    List<String> currentWeaknesses = List.from(state.weaknesses);
    
    // Content-Based Trigger: If user fails, add tag to recommendations
    if (categoryFailed != null && !currentWeaknesses.contains(categoryFailed)) {
      currentWeaknesses.add(categoryFailed);
    }

    int totalPoints = state.points + gainedPoints;
    int newLevel = (totalPoints ~/ 100) + 1; // Level up every 100 points

    emit(ProfileState(
      points: totalPoints,
      level: newLevel,
      weaknesses: currentWeaknesses,
    ));
  }
}