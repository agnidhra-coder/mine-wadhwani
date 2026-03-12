import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/usecases/usecase.dart';
import 'package:mine_wadhwani/domain/usecases/checklist_usecases.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_event.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_state.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final GetChecklistUseCase getChecklistUseCase;
  final SubmitChecklistUseCase submitChecklistUseCase;

  ChecklistBloc({
    required this.getChecklistUseCase,
    required this.submitChecklistUseCase,
  }) : super(const ChecklistInitial()) {
    on<FetchChecklist>(_onFetchChecklist);
    on<UpdateAnswer>(_onUpdateAnswer);
    on<UpdateComment>(_onUpdateComment);
    on<SubmitChecklist>(_onSubmitChecklist);
  }

  Future<void> _onFetchChecklist(
    FetchChecklist event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(const ChecklistLoading());
    final result = await getChecklistUseCase(const NoParams());
    result.fold(
      (failure) => emit(ChecklistError(message: failure.message)),
      (questions) => emit(ChecklistLoaded(questions: questions)),
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
          checklistData: questions,
        ),
      );
      result.fold(
        (failure) {
          emit(ChecklistError(message: failure.message));
          emit(ChecklistLoaded(questions: questions));
        },
        (_) => emit(const ChecklistSubmitted()),
      );
    }
  }
}
