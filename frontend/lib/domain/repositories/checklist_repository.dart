import 'package:dartz/dartz.dart';
import 'package:mine_wadhwani/core/error/failures.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';

abstract class ChecklistRepository {
  Future<Either<Failure, List<ChecklistModel>>> getChecklist();

  /// Submits checklist and returns the inspectionId on success.
  Future<Either<Failure, String>> submitChecklist({
    required String supervisorId,
    required String mineName,
    required String mineType,
    required String area,
    required int shift,
    required String inspectionType,
    required List<ChecklistModel> checklistData,
    required String date,
    required String startTime,
    required String endTime,
  });

  Future<Either<Failure, List<String>>> uploadMedia({
    required String inspectionId,
    required int questionIndex,
    required List<String> filePaths,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getSavedData({
    String? mineName,
    int? shift,
    String? inspectionType,
    String? date,
    String? inspectorId,
  });
}
