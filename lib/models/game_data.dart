import 'intro.dart';
import 'levels.dart';

class GameData {
  GameData({
    required this.intro,
    required this.levels
  });

  final Intro intro;
  final Levels levels;

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      intro: Intro.fromJson(json['intro']),
      levels: Levels.fromJson(json['levels'])
    );
  }
}