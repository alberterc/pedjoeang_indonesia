import 'narration.dart';
import 'levels.dart';

class GameData {
  GameData({
    required this.narration,
    required this.levels
  });

  final Narration narration;
  final Levels levels;

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      narration: Narration.fromJson(json['narration']),
      levels: Levels.fromJson(json['levels'])
    );
  }
}