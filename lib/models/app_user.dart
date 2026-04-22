import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String name;
  final String programme;
  final String level;
  final List<String> interests;

  const AppUser({
    required this.name,
    required this.programme,
    required this.level,
    required this.interests,
  });

  AppUser copyWith({
    String? name,
    String? programme,
    String? level,
    List<String>? interests,
  }) {
    return AppUser(
      name: name ?? this.name,
      programme: programme ?? this.programme,
      level: level ?? this.level,
      interests: interests ?? this.interests,
    );
  }

  @override
  List<Object?> get props => [name, programme, level, interests];
}