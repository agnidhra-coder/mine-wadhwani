import 'package:equatable/equatable.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object?> get props => [];
}

class FetchChecklist extends ChecklistEvent {
  const FetchChecklist();
}

class UpdateAnswer extends ChecklistEvent {
  final String questionCode;
  final String answer;

  const UpdateAnswer({required this.questionCode, required this.answer});

  @override
  List<Object?> get props => [questionCode, answer];
}

class UpdateComment extends ChecklistEvent {
  final String questionCode;
  final String comment;

  const UpdateComment({required this.questionCode, required this.comment});

  @override
  List<Object?> get props => [questionCode, comment];
}

class SubmitChecklist extends ChecklistEvent {
  final String supervisorId;

  const SubmitChecklist({required this.supervisorId});

  @override
  List<Object?> get props => [supervisorId];
}
