import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/data/repositories/draft_repository.dart';
import 'package:mine_wadhwani/presentation/bloc/draft_bloc/draft_event.dart';
import 'package:mine_wadhwani/presentation/bloc/draft_bloc/draft_state.dart';

class DraftBloc extends Bloc<DraftEvent, DraftState> {
  final DraftRepository _repo;

  DraftBloc(this._repo) : super(const DraftInitial()) {
    on<LoadDrafts>(_onLoad);
    on<SaveDraft>(_onSave);
    on<DeleteDraft>(_onDelete);
  }

  Future<void> _onLoad(LoadDrafts event, Emitter<DraftState> emit) async {
    emit(const DraftLoading());
    try {
      final drafts = await _repo.getAllDrafts();
      emit(DraftLoaded(drafts));
    } catch (e) {
      emit(DraftError(e.toString()));
    }
  }

  Future<void> _onSave(SaveDraft event, Emitter<DraftState> emit) async {
    try {
      await _repo.saveDraft(event.draft);
      final drafts = await _repo.getAllDrafts();
      emit(DraftSaved(drafts));
    } catch (e) {
      emit(DraftError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteDraft event, Emitter<DraftState> emit) async {
    try {
      await _repo.deleteDraft(event.id);
      final drafts = await _repo.getAllDrafts();
      emit(DraftLoaded(drafts));
    } catch (e) {
      emit(DraftError(e.toString()));
    }
  }
}