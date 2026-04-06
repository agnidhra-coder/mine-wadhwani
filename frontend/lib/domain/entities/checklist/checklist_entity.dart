import 'package:equatable/equatable.dart';

class ChecklistEntity extends Equatable {
  final String questionCode;
  final String mainTopic;
  final String subTopic;
  final String questionText;
  final String answer;
  final String comment;

  const ChecklistEntity({
    required this.questionCode,
    required this.mainTopic,
    required this.subTopic,
    required this.questionText,
    this.answer = '',
    this.comment = '',
  });

  @override
  List<Object?> get props => [
        questionCode,
        mainTopic,
        subTopic,
        questionText,
        answer,
        comment,
      ];
}
