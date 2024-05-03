class Player {
  final int id;
  final int currLevel;
  final int unlockedLevelCount;

  Player({
    required this.id,
    required this.currLevel,
    required this.unlockedLevelCount
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'currLevel': currLevel,
      'unlockedLevelCount': unlockedLevelCount
    };
  }

  @override
  String toString() {
    return 'Player{id: $id, currLevel: $currLevel, unlockedLevelCount: $unlockedLevelCount}';
  }
}