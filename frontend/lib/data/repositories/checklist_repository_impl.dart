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
  }) async {
    try {
      final inspectionId = await remoteDataSource.submitChecklist(
        supervisorId: supervisorId,
        mineName: mineName,
        mineType: mineType,
        area: area,
        shift: shift,
        inspectionType: inspectionType,
        checklistData: checklistData,
        date: date,
        startTime: startTime,
        endTime: endTime,
      );
      return Right(inspectionId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadMedia({
    required String inspectionId,
    required int questionIndex,
    required List<String> filePaths,
  }) async {
    try {
      final urls = await remoteDataSource.uploadMedia(
        inspectionId: inspectionId,
        questionIndex: questionIndex,
        filePaths: filePaths,
      );
      return Right(urls);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getSavedData({
    String? mineName,
    int? shift,
    String? inspectionType,
    String? date,
    String? inspectorId,
  }) async {
    try {
      final data = await remoteDataSource.getSavedData(
        mineName: mineName,
        shift: shift,
        inspectionType: inspectionType,
        date: date,
        inspectorId: inspectorId,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
