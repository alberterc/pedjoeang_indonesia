import 'puzzle.dart';

class Levels {
  Levels({
    required this.levels
  });

  final List<Level> levels;

  factory Levels.fromJson(Map<String, dynamic> json) {
    final levels = List<Level>.from(
      json['levels'].map((x) => Level.fromJson(x))
    );
    return Levels(
      levels: levels
    );
  }
}

class Level {
  Level({
    required this.level,
    required this.puzzles
  });

  final int level;
  final List<Puzzle> puzzles;

  factory Level.fromJson(Map<String, dynamic> json) {
    final level = json['level'];
    final puzzles = List<Puzzle>.from(
      json['puzzles'].map((x) => Puzzle.fromJson(x))
    );
    return Level(
      level: level,
      puzzles: puzzles
    );
  }
}