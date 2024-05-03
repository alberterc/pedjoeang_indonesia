class Narration {
  Narration({
    required this.intro,
    required this.outro
  });

  final String intro;
  final String outro;

  factory Narration.fromJson(Map<String, dynamic> json) {
    return Narration(
      intro: json['intro'],
      outro: json['outro']
    );
  }
}