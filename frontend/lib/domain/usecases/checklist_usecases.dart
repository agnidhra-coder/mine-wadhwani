import 'package:dartz/dartz.dart';
import 'package:mine_wadhwani/core/error/failures.dart';
import 'package:mine_wadhwani/core/usecases/usecase.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/domain/repositories/checklist_repository.dart';

// ──────────────────────────────────────────────────────────
// GET /get-form-data  →  fetches questionnaire template
// ──────────────────────────────────────────────────────────

class GetChecklistUseCase extends UseCase<List<ChecklistModel>, NoParams> {
  final ChecklistRepository repository;

  GetChecklistUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChecklistModel>>> call(NoParams params) {
    return repository.getChecklist();
  }
}

// ──────────────────────────────────────────────────────────
// POST /save-data  →  submit completed checklist
// Returns the newly created inspectionId.
// ──────────────────────────────────────────────────────────

class SubmitChecklistParams {
  final String supervisorId;
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;
  final List<ChecklistModel> checklistData;
  final String date;
  final String startTime;
  final String endTime;

  const SubmitChecklistParams({
    required this.supervisorId,
    required this.mineName,
    required this.mineType,
    required this.area,
    required this.shift,
    required this.inspectionType,
    required this.checklistData,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}

class SubmitChecklistUseCase extends UseCase<String, SubmitChecklistParams> {
  final ChecklistRepository repository;

  SubmitChecklistUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SubmitChecklistParams params) {
    return repository.submitChecklist(
      supervisorId: params.supervisorId,
      mineName: params.mineName,
      mineType: params.mineType,
      area: params.area,
      shift: params.shift,
      inspectionType: params.inspectionType,
      checklistData: params.checklistData,
      date: params.date,
      startTime: params.startTime,
      endTime: params.endTime,
    );
  }
}

// ──────────────────────────────────────────────────────────
// POST /upload-media/:inspectionId/:questionIndex
// ──────────────────────────────────────────────────────────

class UploadMediaParams {
  final String inspectionId;
  final int questionIndex;
  final List<String> filePaths;

  const UploadMediaParams({
    required this.inspectionId,
    required this.questionIndex,
    required this.filePaths,
  });
}

class UploadMediaUseCase extends UseCase<List<String>, UploadMediaParams> {
  final ChecklistRepository repository;

  UploadMediaUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(UploadMediaParams params) {
    return repository.uploadMedia(
      inspectionId: params.inspectionId,
      questionIndex: params.questionIndex,
      filePaths: params.filePaths,
    );
  }
}

// ──────────────────────────────────────────────────────────
// GET /saved-data  →  fetch previously submitted inspections
// ──────────────────────────────────────────────────────────

class GetSavedDataParams {
  final String? mineName;
  final int? shift;
  final String? inspectionType;
  final String? date;
  final String? inspectorId;

  const GetSavedDataParams({
    this.mineName,
    this.shift,
    this.inspectionType,
    this.date,
    this.inspectorId,
  });
}

class GetSavedDataUseCase
    extends UseCase<List<Map<String, dynamic>>, GetSavedDataParams> {
  final ChecklistRepository repository;

  GetSavedDataUseCase(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      GetSavedDataParams params) {
    return repository.getSavedData(
      mineName: params.mineName,
      shift: params.shift,
      inspectionType: params.inspectionType,
      date: params.date,
      inspectorId: params.inspectorId,
    );
  }
}
