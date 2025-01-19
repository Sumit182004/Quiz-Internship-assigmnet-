class Question {
  final String description;
  final List<Option> options;
  final String correctAnswer;

  Question({required this.description, required this.options, required this.correctAnswer});

  factory Question.fromJson(Map<String, dynamic> json) {
    var list = json['options'] as List;
    List<Option> optionsList = list.map((i) => Option.fromJson(i)).toList();

    return Question(
      description: json['description'],
      options: optionsList,
      correctAnswer: json['options'].firstWhere((opt) => opt['is_correct'] == true)['description'],
    );
  }
}

class Option {
  final String description;
  final bool isCorrect;

  Option({required this.description, required this.isCorrect});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      description: json['description'],
      isCorrect: json['is_correct'],
    );
  }
}

class Quiz {
  final String title;
  final String topic;
  final List<Question> questions;

  Quiz({required this.title, required this.topic, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    var list = json['questions'] as List;
    List<Question> questionsList = list.map((i) => Question.fromJson(i)).toList();

    return Quiz(
      title: json['title'],
      topic: json['topic'],
      questions: questionsList,
    );
  }
}
