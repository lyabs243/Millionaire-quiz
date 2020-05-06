class Answer {

  int id;
  int id_question;
  String description;
  bool is_valid_answer;

  Answer(this.id, this.id_question, this.description, this.is_valid_answer);

  static Answer getFromMap(Map item){

    int id = int.parse(item['id']);
    String description = item['description'];
    int id_question = int.parse(item['id_question']);
    bool is_valid_answer = int.parse(item['is_valid_answer']) == 1;

    Answer answer = Answer(id, id_question, description, is_valid_answer);

    return answer;
  }
}