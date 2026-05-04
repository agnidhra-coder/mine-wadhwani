import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/usecases/usecase.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/data/models/checklist/pending_image.dart';
import 'package:mine_wadhwani/domain/usecases/checklist_usecases.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_event.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kProgressKey = 'checklist_progress';
const _kStartTimeKey = 'checklist_start_time';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final GetChecklistUseCase getChecklistUseCase;
  final SubmitChecklistUseCase submitChecklistUseCase;
  final UploadMediaUseCase uploadMediaUseCase;
  final GetSavedDataUseCase getSavedDataUseCase;
  final SharedPreferences sharedPreferences;

  ChecklistBloc({
    required this.getChecklistUseCase,
    required this.submitChecklistUseCase,
    required this.uploadMediaUseCase,
    required this.getSavedDataUseCase,
    required this.sharedPreferences,
  }) : super(const ChecklistInitial()) {
    on<FetchChecklist>(_onFetchChecklist);
    on<UpdateAnswer>(_onUpdateAnswer);
    on<UpdateComment>(_onUpdateComment);
    on<SubmitChecklist>(_onSubmitChecklist);
    on<AddLocalImages>(_onAddLocalImages);
    on<RemoveLocalImage>(_onRemoveLocalImage);
    on<FetchSavedData>(_onFetchSavedData);
    on<SetCustomChecklistData>(_onSetCustomChecklistData);
  }

  // ── SharedPreferences helpers ──────────────────────────

  Map<String, Map<String, String>> _loadSavedProgress() {
    final raw = sharedPreferences.getString(_kProgressKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (code, value) => MapEntry(
        code,
        Map<String, String>.from(value as Map),
      ),
    );
  }

  void _saveProgress(List<ChecklistModel> questions) {
    final progress = {
      for (final q in questions)
        if (q.answer.isNotEmpty || q.comment.isNotEmpty)
          q.questionCode: {'answer': q.answer, 'comment': q.comment},
    };
    sharedPreferences.setString(_kProgressKey, jsonEncode(progress));
  }

  void _clearProgress() {
    sharedPreferences.remove(_kProgressKey);
    sharedPreferences.remove(_kStartTimeKey);
  }

  void _recordStartTime() {
    if (!sharedPreferences.containsKey(_kStartTimeKey)) {
      sharedPreferences.setString(
          _kStartTimeKey, DateTime.now().toIso8601String());
    }
  }

  String _getStartTime() {
    return sharedPreferences.getString(_kStartTimeKey) ??
        DateTime.now().toIso8601String();
  }

  // ── Event handlers ─────────────────────────────────────

  Future<void> _onFetchChecklist(
    FetchChecklist event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(const ChecklistLoading());
    final result = await getChecklistUseCase(const NoParams());
    result.fold(
      (failure) => emit(ChecklistError(message: failure.message)),
      (questions) {
        // Record the time the user started filling the checklist
        _recordStartTime();

        final saved = _loadSavedProgress();
        final merged = questions.map((q) {
          final savedEntry = saved[q.questionCode];
          if (savedEntry != null) {
            return q.copyWith(
              answer: savedEntry['answer'] ?? q.answer,
              comment: savedEntry['comment'] ?? q.comment,
            );
          }
          return q;
        }).toList();
        emit(ChecklistLoaded(questions: merged));
      },
    );
  }

  void _onUpdateAnswer(
    UpdateAnswer event,
    Emitter<ChecklistState> emit,
  ) {
    final currentState = state;
    if (currentState is ChecklistLoaded) {
      final updatedQuestions = currentState.questions.map((q) {
        if (q.questionCode == event.questionCode) {
          return q.copyWith(answer: event.answer);
        }
        return q;
      }).toList();
      _saveProgress(updatedQuestions);
      emit(ChecklistLoaded(
        questions: updatedQuestions,
        pendingImages: currentState.pendingImages,
      ));
    }
  }

  void _onUpdateComment(
    UpdateComment event,
    Emitter<ChecklistState> emit,
  ) {
    final currentState = state;
    if (currentState is ChecklistLoaded) {
      final updatedQuestions = currentState.questions.map((q) {
        if (q.questionCode == event.questionCode) {
          return q.copyWith(comment: event.comment);
        }
        return q;
      }).toList();
      _saveProgress(updatedQuestions);
      emit(ChecklistLoaded(
        questions: updatedQuestions,
        pendingImages: currentState.pendingImages,
      ));
    }
  }

  void _onSetCustomChecklistData(
    SetCustomChecklistData event,
    Emitter<ChecklistState> emit,
  ) {
    _recordStartTime();
    emit(ChecklistLoaded(questions: event.checklistData));
  }

  void _onAddLocalImages(
    AddLocalImages event,
    Emitter<ChecklistState> emit,
  ) {
    final currentState = state;
    if (currentState is ChecklistLoaded) {
      final updatedPending =
          Map<String, List<PendingImage>>.from(currentState.pendingImages);
      final existing =
          List<PendingImage>.from(updatedPending[event.questionCode] ?? []);
      existing.addAll(event.images);
      updatedPending[event.questionCode] = existing;

      emit(ChecklistLoaded(
        questions: currentState.questions,
        pendingImages: updatedPending,
      ));
    }
  }

  void _onRemoveLocalImage(
    RemoveLocalImage event,
    Emitter<ChecklistState> emit,
  ) {
    final currentState = state;
    if (currentState is ChecklistLoaded) {
      final updatedPending =
          Map<String, List<PendingImage>>.from(currentState.pendingImages);
      final existing =
          List<PendingImage>.from(updatedPending[event.questionCode] ?? []);
      if (event.imageIndex < existing.length) {
        existing.removeAt(event.imageIndex);
      }
      updatedPending[event.questionCode] = existing;

      emit(ChecklistLoaded(
        questions: currentState.questions,
        pendingImages: updatedPending,
      ));
    }
  }

  Future<void> _onSubmitChecklist(
    SubmitChecklist event,
    Emitter<ChecklistState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChecklistLoaded) {
      final questions = currentState.questions;
      final pendingImages = currentState.pendingImages;
      emit(ChecklistSubmitting(questions: questions));

      final now = DateTime.now().toIso8601String();
      final startTime = _getStartTime();

      // Step 1: Submit the checklist → get back inspectionId
      final result = await submitChecklistUseCase(
        SubmitChecklistParams(
          supervisorId: event.supervisorId,
          mineName: event.mineName,
          mineType: event.mineType,
          area: event.area,
          shift: event.shift,
          inspectionType: event.inspectionType,
          checklistData: questions,
          date: now,
          startTime: startTime,
          endTime: now,
          completed: event.completed,
          observations: event.observations,
          signature: event.signature,
        ),
      );

      await result.fold(
        (failure) async {
          emit(ChecklistError(message: failure.message));
          emit(ChecklistLoaded(
            questions: questions,
            pendingImages: pendingImages,
          ));
        },
        (inspectionId) async {
          debugPrint('Checklist submitted. inspectionId=$inspectionId');

          // Step 2: Upload any pending images for each question
          if (pendingImages.isNotEmpty) {
            for (final entry in pendingImages.entries) {
              final questionCode = entry.key;
              final images = entry.value;
              if (images.isEmpty) continue;

              // Find the index of this question in the questions list
              final questionIndex = questions.indexWhere(
                  (q) => q.questionCode == questionCode);
              if (questionIndex == -1) continue;

              // Extract file paths from PendingImage objects
              final filePaths = images.map((img) => img.filePath).toList();

              debugPrint(
                  'Uploading ${filePaths.length} images for question $questionCode (index $questionIndex)');

              final uploadResult = await uploadMediaUseCase(
                UploadMediaParams(
                  inspectionId: inspectionId,
                  questionIndex: questionIndex,
                  filePaths: filePaths,
                ),
              );

              uploadResult.fold(
                (failure) => debugPrint(
                    'Image upload failed for $questionCode: ${failure.message}'),
                (urls) => debugPrint(
                    'Uploaded ${urls.length} images for $questionCode: $urls'),
              );
            }
          }

          _clearProgress();
          emit(const ChecklistSubmitted());
        },
      );
    }
  }

  Future<void> _onFetchSavedData(
    FetchSavedData event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(const ChecklistLoading());
    final result = await getSavedDataUseCase(
      GetSavedDataParams(
        mineName: event.mineName,
        shift: event.shift,
        inspectionType: event.inspectionType,
        date: event.date,
        inspectorId: event.inspectorId,
      ),
    );
    result.fold(
      (failure) => emit(ChecklistError(message: failure.message)),
      (savedForms) => emit(SavedDataLoaded(savedForms: savedForms)),
    );
  }
}
