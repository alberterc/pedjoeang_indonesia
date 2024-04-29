class Intro {
  Intro({
    required this.text
  });

  final String text;

  factory Intro.fromJson(Map<String, dynamic> json) {
    return Intro(
      text: json['text']
    );
  }
}