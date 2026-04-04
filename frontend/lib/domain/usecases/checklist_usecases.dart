import 'package:dartz/dartz.dart';
import 'package:mine_wadhwani/core/error/failures.dart';
import 'package:mine_wadhwani/core/usecases/usecase.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/domain/repositories/checklist_repository.dart';

class GetChecklistUseCase extends UseCase<List<ChecklistModel>, NoParams> {
  final ChecklistRepository repository;

  GetChecklistUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChecklistModel>>> call(NoParams params) {
    return repository.getChecklist();
  }
}

class SubmitChecklistParams {
  final String supervisorId;
  final List<ChecklistModel> checklistData;

  const SubmitChecklistParams({
    required this.supervisorId,
    required this.checklistData,
  });
}

class SubmitChecklistUseCase extends UseCase<void, SubmitChecklistParams> {
  final ChecklistRepository repository;

  SubmitChecklistUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitChecklistParams params) {
    return repository.submitChecklist(
      supervisorId: params.supervisorId,
      checklistData: params.checklistData,
    );
  }
}
