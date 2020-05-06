import 'package:flutter/material.dart';
import 'package:millionaire_quiz/models/answer.dart';
import 'package:millionaire_quiz/services/api.dart';
import 'package:millionaire_quiz/services/constants.dart' as constants;

class Question {

  int id;
  String description;
  int level;

  List<Answer> answers;

  static final String URL_GET_QUESTIONS = constants.BASE_URL + 'index.php/api/get_questions/';

  Question(this.id, this.description, this.level, this.answers);

  static Future getQuestions(BuildContext context, int level) async {
    List<Question> questions = [];
    await Api(context).getJsonFromServer(
        URL_GET_QUESTIONS + level.toString() + '/' + constants.QUESTION_NUMBER.toString()
        , null).then((map) {
      if (map != null) {
        if(map['data'] != null) {
          for (int i = 0; i < map['data'].length; i++) {
            Question question = Question.getFromMap(map['data'][i]);
            questions.add(question);
          }
        }
      }
    });
    return questions;
  }

  static Question getFromMap(Map item){

    int id = int.parse(item['id']);
    String description = item['description'];
    int level = int.parse(item['level']);
    List<Answer> answers = [];

    //get answers
    for (int i = 0; i < item['answers'].length; i++) {
      Answer answer = Answer.getFromMap(item['answers'][i]);
      answers.add(answer);
    }

    Question question = Question(id, description, level, answers);

    return question;
  }
}