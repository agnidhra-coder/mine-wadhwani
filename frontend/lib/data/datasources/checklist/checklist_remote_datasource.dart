import 'package:mine_wadhwani/core/error/exceptions.dart';
import 'package:mine_wadhwani/core/network/api_client.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';

abstract class ChecklistRemoteDataSource {
  Future<List<ChecklistModel>> fetchChecklist();
  Future<void> submitChecklist({
    required String supervisorId,
    required List<ChecklistModel> checklistData,
  });
}

class ChecklistRemoteDataSourceImpl implements ChecklistRemoteDataSource {
  final ApiClient apiClient;

  ChecklistRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ChecklistModel>> fetchChecklist() async {
    try {
      final response = await apiClient.request(
        path: '/api/v1/forms-data/get-form-data',
        method: HttpMethod.get,
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
    required List<ChecklistModel> checklistData,
  }) async {
    try {
      await apiClient.request(
        path: '/api/v1/forms-data/save-data',
        method: HttpMethod.post,
        data: {
          'mineId': supervisorId,
          'operationalDate': DateTime.now().toIso8601String(),
          'shiftNumber': 1,
          'supervisorId': supervisorId,
          'checklistData': checklistData.map((e) => e.toJson()).toList(),
          'startTime': DateTime.now().toIso8601String(),
        },
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
          message: 'Failed to submit checklist: ${e.toString()}');
    }
  }
}
