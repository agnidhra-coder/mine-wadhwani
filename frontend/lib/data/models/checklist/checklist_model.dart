import 'package:mine_wadhwani/domain/entities/checklist/checklist_entity.dart';

class ChecklistModel extends ChecklistEntity {
  const ChecklistModel({
    required super.questionCode,
    required super.mainTopic,
    required super.subTopic,
    required super.questionText,
    super.answer,
    super.comment,
  });

  factory ChecklistModel.fromJson(Map<String, dynamic> json) {
    return ChecklistModel(
      questionCode: json['question_code'] as String? ?? '',
      mainTopic: json['main_topic'] as String? ?? '',
      subTopic: json['sub_topic'] as String? ?? '',
      questionText: json['question_text'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionCode': questionCode,
      'maintopic': mainTopic,
      'subtopic': subTopic,
      'questionText': questionText,
      'answer': answer,
      'comment': comment,
    };
  }

  ChecklistModel copyWith({
    String? questionCode,
    String? mainTopic,
    String? subTopic,
    String? questionText,
    String? answer,
    String? comment,
  }) {
    return ChecklistModel(
      questionCode: questionCode ?? this.questionCode,
      mainTopic: mainTopic ?? this.mainTopic,
      subTopic: subTopic ?? this.subTopic,
      questionText: questionText ?? this.questionText,
      answer: answer ?? this.answer,
      comment: comment ?? this.comment,
    );
  }
}
