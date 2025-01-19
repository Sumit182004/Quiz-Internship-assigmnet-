import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz/quiz_model.dart';


class ApiService {
  final String apiUrl = 'https://api.jsonserve.com/Uw5CrX';

  Future<Quiz> fetchQuizData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return Quiz.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
