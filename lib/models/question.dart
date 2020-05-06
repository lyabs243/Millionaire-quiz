import 'package:millionaire_quiz/models/answer.dart';

class Question {

  int id;
  String description;
  int level;

  List<Answer> answers;

  Question(this.id, this.description, this.level, this.answers);
}