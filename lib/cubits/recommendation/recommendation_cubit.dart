import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/module_data.dart';
import 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecsState> {
  RecommendationCubit() : super(RecsLoaded([]));

  /// Same content-based filter as before: modules whose `tag` appears in weaknesses.
  void getRecommendations(List<String> userWeaknesses) {
    final suggested =
        allCyberModules.where((m) => userWeaknesses.contains(m.tag)).toList();
    emit(RecsLoaded(suggested));
  }
}
