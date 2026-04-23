import 'package:equatable/equatable.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/data/models/checklist/pending_image.dart';

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

  /// Picked images that haven't been uploaded yet, keyed by questionCode.
  final Map<String, List<PendingImage>> pendingImages;

  const ChecklistLoaded({
    required this.questions,
    this.pendingImages = const {},
  });

  @override
  List<Object?> get props => [questions, pendingImages];
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

/// State emitted when saved inspection data has been fetched.
class SavedDataLoaded extends ChecklistState {
  final List<Map<String, dynamic>> savedForms;

  const SavedDataLoaded({required this.savedForms});

  @override
  List<Object?> get props => [savedForms];
}
