import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/usecases/usecase.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/domain/usecases/checklist_usecases.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_event.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kProgressKey = 'checklist_progress';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final GetChecklistUseCase getChecklistUseCase;
  final SubmitChecklistUseCase submitChecklistUseCase;
  final SharedPreferences sharedPreferences;

  ChecklistBloc({
    required this.getChecklistUseCase,
    required this.submitChecklistUseCase,
    required this.sharedPreferences,
  }) : super(const ChecklistInitial()) {
    on<FetchChecklist>(_onFetchChecklist);
    on<UpdateAnswer>(_onUpdateAnswer);
    on<UpdateComment>(_onUpdateComment);
    on<SubmitChecklist>(_onSubmitChecklist);
  }

  /// Loads saved answer/comment map from SharedPreferences.
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

  /// Persists the current answer/comment state for all questions.
  void _saveProgress(List<ChecklistModel> questions) {
    final progress = {
      for (final q in questions)
        if (q.answer.isNotEmpty || q.comment.isNotEmpty)
          q.questionCode: {'answer': q.answer, 'comment': q.comment},
    };
    sharedPreferences.setString(_kProgressKey, jsonEncode(progress));
  }

  /// Clears persisted progress (called after successful submit).
  void _clearProgress() {
    sharedPreferences.remove(_kProgressKey);
  }

  Future<void> _onFetchChecklist(
    FetchChecklist event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(const ChecklistLoading());
    final result = await getChecklistUseCase(const NoParams());
    result.fold(
      (failure) => emit(ChecklistError(message: failure.message)),
      (questions) {
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
      emit(ChecklistLoaded(questions: updatedQuestions));
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
      emit(ChecklistLoaded(questions: updatedQuestions));
    }
  }

  Future<void> _onSubmitChecklist(
    SubmitChecklist event,
    Emitter<ChecklistState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChecklistLoaded) {
      final questions = currentState.questions;
      emit(ChecklistSubmitting(questions: questions));
      final result = await submitChecklistUseCase(
        SubmitChecklistParams(
          supervisorId: event.supervisorId,
          mineName: event.mineName,
          mineType: event.mineType,
          area: event.area,
          shift: event.shift,
          inspectionType: event.inspectionType,
          checklistData: questions,
        ),
      );
      result.fold(
        (failure) {
          emit(ChecklistError(message: failure.message));
          emit(ChecklistLoaded(questions: questions));
        },
        (_) {
          _clearProgress();
          emit(const ChecklistSubmitted());
        },
      );
    }
  }
}
