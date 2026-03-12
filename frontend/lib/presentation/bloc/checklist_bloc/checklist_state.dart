import 'package:equatable/equatable.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';

abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object?> get props => [];
}

class ChecklistInitial extends ChecklistState {
  const ChecklistInitial();
}

class ChecklistLoading extends ChecklistState {
  const ChecklistLoading();
}

class ChecklistLoaded extends ChecklistState {
  final List<ChecklistModel> questions;

  const ChecklistLoaded({required this.questions});

  @override
  List<Object?> get props => [questions];
}

class ChecklistSubmitting extends ChecklistState {
  final List<ChecklistModel> questions;

  const ChecklistSubmitting({required this.questions});

  @override
  List<Object?> get props => [questions];
}

class ChecklistSubmitted extends ChecklistState {
  const ChecklistSubmitted();
}

class ChecklistError extends ChecklistState {
  final String message;

  const ChecklistError({required this.message});

  @override
  List<Object?> get props => [message];
}
