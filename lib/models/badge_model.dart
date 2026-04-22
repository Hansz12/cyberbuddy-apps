import 'package:equatable/equatable.dart';

class BadgeModel extends Equatable {
  final String name;
  final bool unlocked;

  const BadgeModel({
    required this.name,
    required this.unlocked,
  });

  BadgeModel copyWith({
    String? name,
    bool? unlocked,
  }) {
    return BadgeModel(
      name: name ?? this.name,
      unlocked: unlocked ?? this.unlocked,
    );
  }

  @override
  List<Object?> get props => [name, unlocked];
}