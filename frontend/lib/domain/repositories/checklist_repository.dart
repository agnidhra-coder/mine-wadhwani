import 'package:dartz/dartz.dart';
import 'package:mine_wadhwani/core/error/failures.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';

abstract class ChecklistRepository {
  Future<Either<Failure, List<ChecklistModel>>> getChecklist();
  Future<Either<Failure, void>> submitChecklist({
    required String supervisorId,
    required String mineName,
    required String mineType,
    required String area,
    required int shift,
    required String inspectionType,
    required List<ChecklistModel> checklistData,
  });
}
