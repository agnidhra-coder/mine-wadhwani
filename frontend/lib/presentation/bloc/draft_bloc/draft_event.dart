import 'package:mine_wadhwani/data/models/draft/inspection_draft_model.dart';

abstract class DraftEvent {
  const DraftEvent();
}

class LoadDrafts extends DraftEvent {
  const LoadDrafts();
}

class SaveDraft extends DraftEvent {
  final InspectionDraft draft;
  const SaveDraft(this.draft);
}

class DeleteDraft extends DraftEvent {
  final String id;
  const DeleteDraft(this.id);
}