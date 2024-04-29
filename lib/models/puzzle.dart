class Puzzle {
  Puzzle({
    required this.order,
    required this.type,
    required this.title,
    required this.solution,
    required this.clueTexts,
    required this.clueImages,
    required this.initialShowClue
  });

  final int order;
  final String type;
  final String title;
  final List<dynamic> solution;
  final List<dynamic> clueTexts;
  final List<String> clueImages;
  final bool initialShowClue;

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    final order = json['order'];
    final type = json['type'];
    final title = json['title'];
    final solution = List<dynamic>.from(json['solution']);
    final clueTexts = List<dynamic>.from(json['clueTexts']);
    final clueImages = List<String>.from(json['clueImages']);
    final initialShowClue = json['initialShowClue'];

    return Puzzle(
      order: order,
      type: type,
      title: title,
      solution: solution,
      clueTexts: clueTexts,
      clueImages: clueImages,
      initialShowClue: initialShowClue
    );
  }
}