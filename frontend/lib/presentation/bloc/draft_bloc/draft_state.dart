import 'package:mine_wadhwani/data/models/draft/inspection_draft_model.dart';

abstract class DraftState {
  const DraftState();
}

class DraftInitial extends DraftState {
  const DraftInitial();
}

class DraftLoading extends DraftState {
  const DraftLoading();
}

class DraftLoaded extends DraftState {
  final List<InspectionDraft> drafts;
  const DraftLoaded(this.drafts);
}

class DraftSaved extends DraftState {
  final List<InspectionDraft> drafts;
  const DraftSaved(this.drafts);
}

class DraftError extends DraftState {
  final String message;
  const DraftError(this.message);
}