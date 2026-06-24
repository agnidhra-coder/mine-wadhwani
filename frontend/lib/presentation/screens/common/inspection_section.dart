// lib/presentation/screens/common/inspection_section.dart
//
// Generic data models shared by ALL inspection types.
// StockpileData and HaulRoadData both use these types.
// StockpileChecklistPage / HaulRoadChecklistPage use InspectionSection
// and InspectionQuestion instead of their own private types.

enum InspectionQuestionType { yesNo, text, dropdown, datepicker }

class InspectionQuestion {
  final String code;
  final String text;
  final InspectionQuestionType type;
  final String? hint;
  final List<String>? options;

  const InspectionQuestion({
    required this.code,
    required this.text,
    this.type = InspectionQuestionType.yesNo,
    this.hint,
    this.options,
  });
}

class InspectionSection {
  final String title;
  final List<InspectionQuestion> questions;

  const InspectionSection({required this.title, required this.questions});
}