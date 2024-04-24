class Puzzle {
  Puzzle({
    required this.type,
    required this.title,
    required this.solution,
    required this.clueTexts,
    required this.clueImages,
    required this.initialShowClue
  });

  final String type;
  final String title;
  final List<dynamic> solution;
  final List<String> clueTexts;
  final List<String> clueImages;
  final bool initialShowClue;

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final title = json['title'];
    final solution = List<dynamic>.from(json['solution']);
    final clueTexts = List<String>.from(json['clueTexts']);
    final clueImages = List<String>.from(json['clueImages']);
    final initialShowClue = json['initialShowClue'];

    return Puzzle(
      type: type,
      title: title,
      solution: solution,
      clueTexts: clueTexts,
      clueImages: clueImages,
      initialShowClue: initialShowClue
    );
  }
}