import 'package:equatable/equatable.dart';

import '../../data/module_data.dart';

abstract class RecsState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecsLoaded extends RecsState {
  final List<CyberModule> recommendedModules;

  RecsLoaded(this.recommendedModules);

  @override
  List<Object> get props => [recommendedModules];
}
