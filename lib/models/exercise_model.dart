class Exercise {
  final String id;
  final String level;
  final String theme;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? imageUrl;
  final int difficulty;

  Exercise({
    required this.id,
    required this.level,
    required this.theme,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.imageUrl,
    this.difficulty = 1,
  });

  factory Exercise.fromFirestore(Map<String, dynamic> data, String id) {
    return Exercise(
      id: id,
      level: data['level'],
      theme: data['theme'],
      question: data['question'],
      options: List<String>.from(data['options']),
      correctAnswer: data['correctAnswer'],
      imageUrl: data['imageUrl'],
      difficulty: data['difficulty'] ?? 1,
    );
  }
}