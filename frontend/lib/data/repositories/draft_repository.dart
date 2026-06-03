// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mine_wadhwani/data/models/draft/inspection_draft_model.dart';

// abstract class DraftRepository {
//   Future<void> saveDraft(InspectionDraft draft);
//   Future<List<InspectionDraft>> getAllDrafts();
//   Future<void> deleteDraft(String id);
//   Future<InspectionDraft?> getDraftById(String id);
// }

// class DraftRepositoryImpl implements DraftRepository {
//   static const _key = 'inspection_drafts';

//   @override
//   Future<void> saveDraft(InspectionDraft draft) async {
//     final prefs = await SharedPreferences.getInstance();
//     final drafts = await getAllDrafts();

//     // Replace if same id exists, else append
//     final idx = drafts.indexWhere((d) => d.id == draft.id);
//     if (idx != -1) {
//       drafts[idx] = draft;
//     } else {
//       drafts.add(draft);
//     }

//     await prefs.setString(
//       _key,
//       jsonEncode(drafts.map((d) => d.toJson()).toList()),
//     );
//   }

//   @override
//   Future<List<InspectionDraft>> getAllDrafts() async {
//     final prefs = await SharedPreferences.getInstance();
//     final raw = prefs.getString(_key);
//     if (raw == null) return [];
//     final list = jsonDecode(raw) as List;
//     return list.map((e) => InspectionDraft.fromJson(e)).toList();
//   }

//   @override
//   Future<void> deleteDraft(String id) async {
//     final prefs = await SharedPreferences.getInstance();
//     final drafts = await getAllDrafts();
//     drafts.removeWhere((d) => d.id == id);
//     await prefs.setString(
//       _key,
//       jsonEncode(drafts.map((d) => d.toJson()).toList()),
//     );
//   }

//   @override
//   Future<InspectionDraft?> getDraftById(String id) async {
//     final drafts = await getAllDrafts();
//     try {
//       return drafts.firstWhere((d) => d.id == id);
//     } catch (_) {
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mine_wadhwani/data/models/draft/inspection_draft_model.dart';

abstract class DraftRepository {
  Future<void> saveDraft(InspectionDraft draft);
  Future<List<InspectionDraft>> getAllDrafts();
  Future<void> deleteDraft(String id);
  Future<InspectionDraft?> getDraftById(String id);
}

class DraftRepositoryImpl implements DraftRepository {
  final SharedPreferences _prefs;
  static const _key = 'inspection_drafts';

  DraftRepositoryImpl({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

  @override
  Future<void> saveDraft(InspectionDraft draft) async {
    final drafts = await getAllDrafts();

    // Replace if same id exists, else append
    final idx = drafts.indexWhere((d) => d.id == draft.id);
    if (idx != -1) {
      drafts[idx] = draft;
    } else {
      drafts.add(draft);
    }

    await _prefs.setString(
      _key,
      jsonEncode(drafts.map((d) => d.toJson()).toList()),
    );
  }

  @override
  Future<List<InspectionDraft>> getAllDrafts() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => InspectionDraft.fromJson(e)).toList();
  }

  @override
  Future<void> deleteDraft(String id) async {
    final drafts = await getAllDrafts();
    drafts.removeWhere((d) => d.id == id);
    await _prefs.setString(
      _key,
      jsonEncode(drafts.map((d) => d.toJson()).toList()),
    );
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