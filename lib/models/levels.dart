import 'puzzle.dart';

class Levels {
  Levels({
    required this.levels
  });

  final List<Level> levels;

  factory Levels.fromJson(List<dynamic> json) {
    final levels = List<Level>.from(
      json.map((x) => Level.fromJson(x))
    );
    return Levels(
      levels: levels
    );
  }
}

class Level {
  Level({
    required this.level,
    required this.puzzles,
    required this.mainPuzzle
  });

  final int level;
  final List<Puzzle> puzzles;
  final Puzzle mainPuzzle;

  factory Level.fromJson(Map<String, dynamic> json) {
    final level = json['level'];
    final puzzles = List<Puzzle>.from(
      json['puzzles'].map((x) => Puzzle.fromJson(x))
    );
    final mainPuzzle = Puzzle.fromJson(json['mainPuzzle']);
    return Level(
      level: level,
      puzzles: puzzles,
      mainPuzzle: mainPuzzle
    );
  }
}