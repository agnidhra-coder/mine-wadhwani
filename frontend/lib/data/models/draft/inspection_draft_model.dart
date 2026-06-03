class InspectionDraft {
  final String id;
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;
  final DateTime savedAt;
  final int answeredCount;
  final int totalCount;
  final List<Map<String, dynamic>> answers; // serialized checklist answers

  const InspectionDraft({
    required this.id,
    required this.mineName,
    required this.mineType,
    required this.area,
    required this.shift,
    required this.inspectionType,
    required this.savedAt,
    required this.answeredCount,
    required this.totalCount,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'mineName': mineName,
        'mineType': mineType,
        'area': area,
        'shift': shift,
        'inspectionType': inspectionType,
        'savedAt': savedAt.toIso8601String(),
        'answeredCount': answeredCount,
        'totalCount': totalCount,
        'answers': answers,
      };

  factory InspectionDraft.fromJson(Map<String, dynamic> json) =>
      InspectionDraft(
        id: json['id'],
        mineName: json['mineName'],
        mineType: json['mineType'],
        area: json['area'],
        shift: json['shift'],
        inspectionType: json['inspectionType'],
        savedAt: DateTime.parse(json['savedAt']),
        answeredCount: json['answeredCount'],
        totalCount: json['totalCount'],
        answers: List<Map<String, dynamic>>.from(json['answers']),
      );
}