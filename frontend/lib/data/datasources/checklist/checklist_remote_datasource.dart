import 'package:flutter/foundation.dart';
import 'package:mine_wadhwani/core/error/exceptions.dart';
import 'package:mine_wadhwani/core/network/api_client.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';

abstract class ChecklistRemoteDataSource {
  Future<List<ChecklistModel>> fetchChecklist();
  Future<void> submitChecklist({
    required String supervisorId,
    required String mineName,
    required String mineType,
    required String area,
    required int shift,
    required String inspectionType,
    required List<ChecklistModel> checklistData,
  });
}

class ChecklistRemoteDataSourceImpl implements ChecklistRemoteDataSource {
  final ApiClient apiClient;

  ChecklistRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ChecklistModel>> fetchChecklist() async {
    try {
      final response = await apiClient.get(
        '/api/v1/forms-data/get-form-data',
      );

      final responseData = response.data as Map<String, dynamic>;
      final List<dynamic> data = responseData['data'] as List<dynamic>;
      return data
          .map((item) =>
              ChecklistModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
          message: 'Failed to fetch checklist: ${e.toString()}');
    }
  }

  @override
  Future<void> submitChecklist({
    required String supervisorId,
    required String mineName,
    required String mineType,
    required String area,
    required int shift,
    required String inspectionType,
    required List<ChecklistModel> checklistData,
  }) async {
    try {
      final payload = {
        'mine_name': mineName,
        'mine_type': mineType,
        'area': area,
        'shift': shift,
        'Inspection_type': inspectionType,
        'Inspector_id': supervisorId,
        'checklistData': checklistData.map((e) => e.toJson()).toList(),
      };
      debugPrint('SUBMIT PAYLOAD: $payload');
      await apiClient.post(
        '/api/v1/forms-data/save-data',
        data: payload,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
          message: 'Failed to submit checklist: ${e.toString()}');
    }
  }
}
