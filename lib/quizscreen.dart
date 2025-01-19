import 'package:flutter/material.dart';
import 'package:quiz/api_service.dart';
import 'package:quiz/quiz_model.dart';
import 'package:quiz/quizresult.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<Quiz> quizData;
  Map<int, String?> answers = {};

  @override
  void initState() {
    super.initState();
    quizData = ApiService().fetchQuizData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz: Genetics and Evolution"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Quiz>(
        future: quizData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          if (snapshot.hasData) {
            Quiz quiz = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: quiz.questions.length,
                itemBuilder: (context, index) {
                  Question question = quiz.questions[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Q${index + 1}: ${question.description}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          ...question.options.map((option) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: answers[index] == option.description
                                      ? Colors.deepPurple
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: RadioListTile<String>(
                                title: Text(
                                  option.description,
                                  style: TextStyle(fontSize: 16),
                                ),
                                value: option.description,
                                groupValue: answers[index],
                                activeColor: Colors.deepPurple,
                                onChanged: (String? value) {
                                  setState(() {
                                    answers[index] = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Center(
            child: Text(
              "No quiz data available",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          int score = 0;
          quizData.then((quiz) {
            for (int i = 0; i < quiz.questions.length; i++) {
              if (answers[i] == quiz.questions[i].correctAnswer) {
                score++;
              }
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizResultScreen(score: score, total: quiz.questions.length),
              ),
            );
          });
        },
        label: Text("Submit"),
        icon: Icon(Icons.check),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
