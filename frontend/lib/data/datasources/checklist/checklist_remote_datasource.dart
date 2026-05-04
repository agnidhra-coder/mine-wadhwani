import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mine_wadhwani/core/error/exceptions.dart';
import 'package:mine_wadhwani/core/network/api_client.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';

abstract class ChecklistRemoteDataSource {
  Future<List<ChecklistModel>> fetchChecklist();

  /// Submits the checklist and returns the inspectionId from the backend.
  Future<String> submitChecklist({
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
    required bool completed,
    String observations = '',
    String signature = '',
  });

  /// Uploads images for a specific question within a saved inspection.
  /// Returns the list of uploaded image URLs.
  Future<List<String>> uploadMedia({
    required String inspectionId,
    required int questionIndex,
    required List<String> filePaths,
  });

  /// Fetches previously saved inspection forms with optional filters.
  Future<List<Map<String, dynamic>>> getSavedData({
    String? mineName,
    int? shift,
    String? inspectionType,
    String? date,
    String? inspectorId,
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
  Future<String> submitChecklist({
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
    required bool completed,
    String observations = '',
    String signature = '',
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
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'completed': completed,
        'observations': observations,
        'signature': signature,
      };
      debugPrint('SUBMIT PAYLOAD: $payload');
      final response = await apiClient.post(
        '/api/v1/forms-data/save-data',
        data: payload,
      );

      // Extract the inspectionId from the response
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      final inspectionId = data['_id'] as String;
      debugPrint('SUBMIT RESPONSE inspectionId: $inspectionId');
      return inspectionId;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
          message: 'Failed to submit checklist: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> uploadMedia({
    required String inspectionId,
    required int questionIndex,
    required List<String> filePaths,
  }) async {
    try {
      final formData = FormData();

      for (final path in filePaths) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(path),
          ),
        );
      }

      debugPrint(
          'UPLOAD MEDIA: inspectionId=$inspectionId, questionIndex=$questionIndex, files=${filePaths.length}');

      final response = await apiClient.multipartPost(
        '/api/v1/forms-data/upload-media/$inspectionId/$questionIndex',
        data: formData,
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      final uploadedUrls = (data['uploadedUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList();

      return uploadedUrls;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
          message: 'Failed to upload media: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSavedData({
    String? mineName,
    int? shift,
    String? inspectionType,
    String? date,
    String? inspectorId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (mineName != null) queryParams['mine_name'] = mineName;
      if (shift != null) queryParams['shift'] = shift;
      if (inspectionType != null) {
        queryParams['Inspection_type'] = inspectionType;
      }
      if (date != null) queryParams['date'] = date;
      if (inspectorId != null) queryParams['Inspector_id'] = inspectorId;

      debugPrint('GET SAVED DATA query: $queryParams');

      final response = await apiClient.get(
        '/api/v1/forms-data/saved-data',
        queryParameters: queryParams,
      );

      final responseData = response.data as Map<String, dynamic>;
      final List<dynamic> data = responseData['data'] as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
          message: 'Failed to fetch saved data: ${e.toString()}');
    }
  }
}
