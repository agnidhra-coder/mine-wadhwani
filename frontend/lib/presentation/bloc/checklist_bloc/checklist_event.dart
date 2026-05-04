import 'package:equatable/equatable.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/data/models/checklist/pending_image.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object?> get props => [];
}

class FetchChecklist extends ChecklistEvent {
  const FetchChecklist();
}

/// Allows injecting arbitrary checklist data into the BLoC (useful for submitting Stockpile or other schemas).
class SetCustomChecklistData extends ChecklistEvent {
  final List<ChecklistModel> checklistData;
  const SetCustomChecklistData(this.checklistData);
  @override
  List<Object?> get props => [checklistData];
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
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;
  final bool completed;
  final String observations;
  final String signature;

  const SubmitChecklist({
    required this.supervisorId,
    required this.mineName,
    required this.mineType,
    required this.area,
    required this.shift,
    required this.inspectionType,
    required this.completed,
    this.observations = '',
    this.signature = '',
  });

  @override
  List<Object?> get props =>
      [supervisorId, mineName, mineType, area, shift, inspectionType, completed, observations, signature];
}

/// Fired when the user picks images for a specific question.
/// Carries both paths (for upload) and bytes (for cross-platform display).
class AddLocalImages extends ChecklistEvent {
  final String questionCode;
  final List<PendingImage> images;

  const AddLocalImages({
    required this.questionCode,
    required this.images,
  });

  @override
  List<Object?> get props => [questionCode, images];
}

/// Fired to remove a locally-added image from a question before submission.
class RemoveLocalImage extends ChecklistEvent {
  final String questionCode;
  final int imageIndex;

  const RemoveLocalImage({
    required this.questionCode,
    required this.imageIndex,
  });

  @override
  List<Object?> get props => [questionCode, imageIndex];
}

/// Fired to fetch previously saved inspections.
class FetchSavedData extends ChecklistEvent {
  final String? mineName;
  final int? shift;
  final String? inspectionType;
  final String? date;
  final String? inspectorId;

  const FetchSavedData({
    this.mineName,
    this.shift,
    this.inspectionType,
    this.date,
    this.inspectorId,
  });

  @override
  List<Object?> get props =>
      [mineName, shift, inspectionType, date, inspectorId];
}
