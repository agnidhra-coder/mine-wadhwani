enum StockpileQuestionType { yesNo, text }

class StockpileQuestion {
  final String code;
  final String text;
  final StockpileQuestionType type;
  final String? hint;

  const StockpileQuestion({
    required this.code,
    required this.text,
    this.type = StockpileQuestionType.yesNo,
    this.hint,
  });
}

class StockpileSection {
  final String title;
  final List<StockpileQuestion> questions;

  const StockpileSection({required this.title, required this.questions});
}

class StockpileData {
  static const List<StockpileSection> sections = [
    StockpileSection(
      title: 'General Information',
      questions: [
        StockpileQuestion(
          code: '1.1',
          text: 'Type of stockpile',
          type: StockpileQuestionType.text,
          hint: 'ROM Coal / Clean Coal / Middlings / Reject / Fines',
        ),
        StockpileQuestion(
          code: '1.2',
          text: 'Approx. stockpile quantity (t)',
          type: StockpileQuestionType.text,
          hint: 'Enter quantity in tonnes',
        ),
        StockpileQuestion(
          code: '1.3',
          text: 'Approx. stockpile height (m)',
          type: StockpileQuestionType.text,
          hint: 'Enter height in metres',
        ),
        StockpileQuestion(
          code: '1.4',
          text: 'Approx. stockpile footprint area (m²)',
          type: StockpileQuestionType.text,
          hint: 'Enter area in square metres',
        ),
        StockpileQuestion(
          code: '1.5',
          text: 'Approx. age of stockpile',
          type: StockpileQuestionType.text,
          hint: 'e.g. 3 months',
        ),
        StockpileQuestion(
          code: '1.6',
          text: 'Last dozing / reshaping date',
          type: StockpileQuestionType.text,
          hint: 'DD/MM/YYYY',
        ),
        StockpileQuestion(
          code: '1.7',
          text: 'Last temperature monitoring date',
          type: StockpileQuestionType.text,
          hint: 'DD/MM/YYYY',
        ),
        StockpileQuestion(
          code: '1.8',
          text: 'Last firefighting / spraying date',
          type: StockpileQuestionType.text,
          hint: 'DD/MM/YYYY',
        ),
      ],
    ),
    StockpileSection(
      title: 'Stockpile Stability & Geometry Check',
      questions: [
        StockpileQuestion(code: '2.1', text: 'Stockpile slope appears stable'),
        StockpileQuestion(code: '2.2', text: 'No signs of over-steepened faces'),
        StockpileQuestion(code: '2.3', text: 'Benches / tiers maintained where required'),
        StockpileQuestion(code: '2.4', text: 'No undercutting at toe of stockpile'),
        StockpileQuestion(code: '2.5', text: 'No overhanging coal mass'),
        StockpileQuestion(code: '2.6', text: 'No sloughing / local collapse visible'),
        StockpileQuestion(code: '2.7', text: 'No cracks / tension cracks on top surface'),
        StockpileQuestion(code: '2.8', text: 'No evidence of subsidence / sink zones'),
        StockpileQuestion(code: '2.9', text: 'Access for dozer / loader is safe'),
        StockpileQuestion(code: '2.10', text: 'Working platform is level and stable'),
      ],
    ),
    StockpileSection(
      title: 'Spontaneous Heating / Fire Risk Check',
      questions: [
        StockpileQuestion(code: '3.1', text: 'No smoke observed from stockpile'),
        StockpileQuestion(code: '3.2', text: 'No steam / vapour emission observed'),
        StockpileQuestion(code: '3.3', text: 'No hot spots identified'),
        StockpileQuestion(code: '3.4', text: 'No burnt smell / heating smell detected'),
        StockpileQuestion(code: '3.5', text: 'Surface temperature appears normal'),
        StockpileQuestion(code: '3.6', text: 'Thermal monitoring done as per schedule'),
        StockpileQuestion(code: '3.7', text: 'Temperature log maintained'),
        StockpileQuestion(code: '3.8', text: 'Water spraying / compaction done where needed'),
        StockpileQuestion(code: '3.9', text: 'No old fire pockets reopened'),
        StockpileQuestion(code: '3.10', text: 'No air ingress through cracks / voids'),
      ],
    ),
    StockpileSection(
      title: 'Water Drainage / Moisture / Runoff Check',
      questions: [
        StockpileQuestion(code: '4.1', text: 'No water stagnation near stockpile toe'),
        StockpileQuestion(code: '4.2', text: 'Drainage channels are clear'),
        StockpileQuestion(code: '4.3', text: 'Garland drains / side drains functional'),
        StockpileQuestion(code: '4.4', text: 'No erosion gullies on stockpile face'),
        StockpileQuestion(code: '4.5', text: 'No water seepage from stockpile'),
        StockpileQuestion(code: '4.6', text: 'Moisture level under control'),
        StockpileQuestion(code: '4.7', text: 'No ponding on top surface'),
        StockpileQuestion(code: '4.8', text: 'Runoff not causing contamination / spillage'),
      ],
    ),
  ];
}
