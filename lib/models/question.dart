import 'dart:math';

import 'package:flutter/material.dart';
import 'package:millionaire_quiz/models/answer.dart';
import 'package:millionaire_quiz/services/api.dart';
import 'package:millionaire_quiz/services/constants.dart' as constants;
import 'package:html_unescape/html_unescape.dart';

class Question {

  int id;
  String description;
  int level;

  List<Answer> answers;

  static final String URL_GET_QUESTIONS = constants.BASE_URL + 'index.php/api/get_questions/';
  static final String URL_GET_OPEN_DB_QUESTIONS = 'https://opentdb.com/api.php?';

  static final List<String> OPEN_DB_DIFFICULTIES = ['easy', 'medium', 'hard'];

  Question(this.id, this.description, this.level, this.answers);

  static Future getQuestions(BuildContext context, int level) async {
    List<Question> questions = [];
    if (constants.QUESTION_FROM_OPEN_TRIVIA_DB) {
      questions = await _getQuestionFromOpenDB(context, level);
    }
    else {
      questions = await _getQuestionFromServer(context, level);
    }
    return questions;
  }

  static Future _getQuestionFromServer(BuildContext context, int level) async {
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

  static Future _getQuestionFromOpenDB(BuildContext context, int level) async {
    List<Question> questions = [];
    await Api(context).getJsonFromServer(
        URL_GET_OPEN_DB_QUESTIONS + 'amount=' + constants.QUESTION_NUMBER.toString() + '&difficulty=' +
            OPEN_DB_DIFFICULTIES[level] + '&type=multiple'
        , null).then((map) {
      if (map != null) {
        if(map['results'] != null) {
          for (int i = 0; i < map['results'].length; i++) {
            String correctAnswer = _parseHtmlString(map['results'][i]['correct_answer']);
            List incorrectAnswers = [];
            for (int j=0; j<map['results'][i]['incorrect_answers'].length; j++) {
              incorrectAnswers.add(_parseHtmlString(map['results'][i]['incorrect_answers'][j]));
            }
            if (correctAnswer != null && incorrectAnswers != null) {
              List<Answer> answers = _initOpenDBAnswers(
                  correctAnswer, incorrectAnswers);
              Question question = Question(-1, _parseHtmlString(map['results'][i]['question']), level, answers);
              questions.add(question);
            }
          }
        }
      }
    });
    return questions;
  }

  static List<Answer> _initOpenDBAnswers(String correctAnswer, List incorrectAnswers) {
    //align answers randomly
    List<Answer> openDBAnswers = [];

    Answer trueAnswer = Answer(-1, -1, correctAnswer, true);
    openDBAnswers.add(trueAnswer);

    incorrectAnswers.forEach((element) {
      Answer falseAnswer = Answer(-1, -1, element, false);
      openDBAnswers.add(falseAnswer);
    });

    List<Answer> answers = shuffle(openDBAnswers);

    return answers;
  }

  static Question getFromMap(Map item) {

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

  static List<Answer> shuffle(List<Answer> items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  static String _parseHtmlString(String htmlString) {
    HtmlUnescape unescape = new HtmlUnescape();
    var text =  unescape.convert(htmlString);
    return text;
  }
}