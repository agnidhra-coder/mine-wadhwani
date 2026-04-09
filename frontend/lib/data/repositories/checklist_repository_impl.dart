import 'package:dartz/dartz.dart';
import 'package:mine_wadhwani/core/error/exceptions.dart';
import 'package:mine_wadhwani/core/error/failures.dart';
import 'package:mine_wadhwani/data/datasources/checklist/checklist_remote_datasource.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/domain/repositories/checklist_repository.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final ChecklistRemoteDataSource remoteDataSource;

  ChecklistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChecklistModel>>> getChecklist() async {
    try {
      final checklist = await remoteDataSource.fetchChecklist();
      return Right(checklist);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> submitChecklist({
    required String supervisorId,
    required String mineName,
    required String mineType,
    required String area,
    required int shift,
    required String inspectionType,
    required List<ChecklistModel> checklistData,
  }) async {
    try {
      await remoteDataSource.submitChecklist(
        supervisorId: supervisorId,
        mineName: mineName,
        mineType: mineType,
        area: area,
        shift: shift,
        inspectionType: inspectionType,
        checklistData: checklistData,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
