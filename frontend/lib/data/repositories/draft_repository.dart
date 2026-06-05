import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mine_wadhwani/core/constants/app_constants.dart';
import 'package:mine_wadhwani/core/network/api_client.dart';
import 'package:mine_wadhwani/data/models/draft/inspection_draft_model.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

abstract class DraftRepository {
  Future<void> saveDraft(InspectionDraft draft);
  Future<List<InspectionDraft>> getAllDrafts();
  Future<void> deleteDraft(String id);
  Future<InspectionDraft?> getDraftById(String id);
}

class DraftRepositoryImpl implements DraftRepository {
  final SharedPreferences _prefs;
  final ApiClient _apiClient;

  DraftRepositoryImpl({
    required SharedPreferences sharedPreferences,
    required ApiClient apiClient,
  })  : _prefs = sharedPreferences,
        _apiClient = apiClient;

  String _getQuestionText(String code) {
    for (final section in StockpileData.sections) {
      for (final q in section.questions) {
        if (q.code == code) return q.text;
      }
    }
    return '';
  }

  @override
  Future<void> saveDraft(InspectionDraft draft) async {
    final userString = _prefs.getString(AppConstants.userKey);
    if (userString == null) throw Exception("User not logged in");
    final userJson = jsonDecode(userString) as Map<String, dynamic>;
    final userId = userJson['_id'] as String;

    final checklistData = <Map<String, dynamic>>[];
    for (final ans in draft.answers) {
      final code = ans['code'] as String? ?? '';
      if (code.isNotEmpty) {
        final media = ans['media'] as String? ?? '';
        checklistData.add({
          'questionCode': code,
          'maintopic': ans['section'] as String? ?? '',
          'subtopic': '',
          'questionText': _getQuestionText(code),
          'answer': ans['answer'] as String? ?? '',
          'comment': ans['comment'] as String? ?? '',
          'imageUrl': media.isNotEmpty ? media.split('||') : <String>[],
          'action': ans['action'] as String? ?? '',
        });
      }
    }

    final payload = {
      if (draft.id.length == 24) 'inspectionId': draft.id,
      'mine_name': draft.mineName,
      'mine_type': draft.mineType,
      'area': draft.area,
      'shift': draft.shift,
      'Inspection_type': draft.inspectionType,
      'Inspector_id': userId,
      'checklistData': checklistData,
      'date': draft.savedAt.toIso8601String(),
      'startTime': draft.savedAt.toIso8601String(),
      'endTime': draft.savedAt.toIso8601String(),
      'completed': false,
    };

    await _apiClient.post('/api/v1/forms-data/save-data', data: payload);
  }

  @override
  Future<List<InspectionDraft>> getAllDrafts() async {
    final userString = _prefs.getString(AppConstants.userKey);
    if (userString == null) return [];
    final userJson = jsonDecode(userString) as Map<String, dynamic>;
    final userId = userJson['_id'] as String;

    final response = await _apiClient.get(
      '/api/v1/forms-data/saved-data',
      queryParameters: {
        'Inspector_id': userId,
        'completed': false,
      },
    );

    final responseData = response.data as Map<String, dynamic>;
    final List<dynamic> data = responseData['data'] as List<dynamic>? ?? [];
    
    final drafts = <InspectionDraft>[];
    for (final doc in data) {
      final map = doc as Map<String, dynamic>;
      final id = map['_id'] as String? ?? '';
      final mineName = map['mine_name'] as String? ?? '';
      final mineType = map['mine_type'] as String? ?? 'Opencast';
      final area = map['area'] as String? ?? '';
      final shift = map['shift'] as int? ?? 1;
      final inspectionType = map['Inspection_type'] as String? ?? '';
      final dateStr = map['date'] as String? ?? map['createdAt'] as String? ?? DateTime.now().toIso8601String();
      final savedAt = DateTime.parse(dateStr);
      
      final checklistData = map['checklistData'] as List<dynamic>? ?? [];
      final answers = checklistData.map((item) {
        final qMap = item as Map<String, dynamic>;
        final code = (qMap['questionCode'] ?? qMap['question_code']) as String? ?? '';
        final section = (qMap['maintopic'] ?? qMap['main_topic']) as String? ?? '';
        final answer = qMap['answer'] as String? ?? '';
        final comment = qMap['comment'] as String? ?? '';
        final action = qMap['action'] as String? ?? '';
        final imageUrls = (qMap['imageUrl'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [];
        final media = imageUrls.join('||');
        
        return {
          'code': code,
          'answer': answer,
          'comment': comment,
          'action': action,
          'media': media,
          'section': section,
        };
      }).toList();

      final answeredCount = checklistData.where((item) {
        final answer = item['answer'] as String? ?? '';
        return answer.isNotEmpty;
      }).length;
      final totalCount = checklistData.length;

      drafts.add(InspectionDraft(
        id: id,
        mineName: mineName,
        mineType: mineType,
        area: area,
        shift: shift,
        inspectionType: inspectionType,
        savedAt: savedAt,
        answeredCount: answeredCount,
        totalCount: totalCount,
        answers: answers,
      ));
    }
    
    return drafts;
  }

  @override
  Future<void> deleteDraft(String id) async {
    if (id.length == 24) {
      await _apiClient.delete('/api/v1/forms-data/delete-draft/$id');
    }
  }

  @override
  Future<InspectionDraft?> getDraftById(String id) async {
    final drafts = await getAllDrafts();
    try {
      return drafts.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}