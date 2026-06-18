// enum StockpileQuestionType { yesNo, text }

// class StockpileQuestion {
//   final String code;
//   final String text;
//   final StockpileQuestionType type;
//   final String? hint;

//   const StockpileQuestion({
//     required this.code,
//     required this.text,
//     this.type = StockpileQuestionType.yesNo,
//     this.hint,
//   });
// }

// class StockpileSection {
//   final String title;
//   final List<StockpileQuestion> questions;

//   const StockpileSection({required this.title, required this.questions});
// }

// class StockpileData {
//   static const List<StockpileSection> sections = [
//     StockpileSection(
//       title: 'General Information',
//       questions: [
//         StockpileQuestion(
//           code: '1.1',
//           text: 'Type of stockpile',
//           type: StockpileQuestionType.text,
//           hint: 'ROM Coal / Clean Coal / Middlings / Reject / Fines',
//         ),
//         StockpileQuestion(
//           code: '1.2',
//           text: 'Approx. stockpile quantity (in tonnes)',
//           type: StockpileQuestionType.text,
//           hint: 'Enter quantity in tonnes',
//         ),
//         StockpileQuestion(
//           code: '1.3',
//           text: 'Average stockpile height (in meteres)',
//           type: StockpileQuestionType.text,
//           hint: 'Enter height in metres',
//         ),
//         StockpileQuestion(
//           code: '1.4',
//           text: 'Approx. stockpile floor area (in square metres)',
//           type: StockpileQuestionType.text,
//           hint: 'Enter area in square metres',
//         ),
//         StockpileQuestion(
//           code: '1.5',
//           text: 'Approx. age of stockpile (in months)',
//           type: StockpileQuestionType.text,
//           hint: 'e.g. 3 months',
//         ),
//         StockpileQuestion(
//           code: '1.6',
//           text: 'Last dozing / reshaping date',
//           type: StockpileQuestionType.text,
//           hint: 'DD/MM/YYYY',
//         ),
//         StockpileQuestion(
//           code: '1.7',
//           text: 'Last temperature monitoring date',
//           type: StockpileQuestionType.text,
//           hint: 'DD/MM/YYYY',
//         ),
//         StockpileQuestion(
//           code: '1.8',
//           text: 'Last firefighting / spraying date',
//           type: StockpileQuestionType.text,
//           hint: 'DD/MM/YYYY',
//         ),
//       ],
//     ),
//     StockpileSection(
//       title: 'Stockpile Structure & Slope Stability',
//       questions: [
//         StockpileQuestion(code: '2.1', text: 'Is the slope angle within permissible limit (≤37.5° from horizontal, unless scientifically justified and permitted)?'),
//         StockpileQuestion(code: '2.2', text: 'For stockpiles exceeding 30 m in height, has benching been done with each bench not exceeding 30 m and overall slope not more than 1V:1.5H?'),
//         StockpileQuestion(code: '2.3', text: 'Is the stockpile face free from any evidence of slope failure?'),
//         StockpileQuestion(code: '2.4', text: 'Has overburden or loose material been dumped in a manner that eliminates risk of sliding?'),
//         StockpileQuestion(code: '2.5', text: 'Is the stockpile toe at least 100 m from any mine opening, railway, public road, or permanent structure not owned by mine owner?'),
//         StockpileQuestion(code: '2.6', text: 'Whether slope stability monitoring study carried out by any scientific agency?'),
//         StockpileQuestion(code: '2.7', text: 'Whether any slope monitoring record maintained in this mine? If yes, then please enter whether slope monitoring records are up to date?'),
//       ],
//     ),
//     StockpileSection(
//       title: 'Spontaneous Heating & Fire Prevention',
//       questions: [
//         StockpileQuestion(code: '3.1', text: 'Is the stockpile free from any visible signs of smoke?'),
//         StockpileQuestion(code: '3.2', text: 'What is the visible extent of smoke effect area? (High/Medium/Low)'),
//         StockpileQuestion(code: '3.3', text: 'What is the current average temperature of the stockpile? (in °C)'),
//         StockpileQuestion(code: '3.4', text: 'Is temperature monitoring being carried out at the stockpile for early detection of heating?'),
//         StockpileQuestion(code: '3.5', text: 'Is carbonaceous shale stored separately and not mixed with the coal stockpile?'),
//         StockpileQuestion(code: '3.6', text: 'Are dead leaves, dry vegetation and combustible waste cleared from around the stockpile?'),
//         StockpileQuestion(code: '3.7', text: 'Is there adequate water supply at sufficient pressure available at the stockpile for fire-fighting purposes?'),
//         StockpileQuestion(code: '3.8', text: 'Are portable fire extinguishers or sand/incombustible material provided at stockpile access points?'),
//         StockpileQuestion(code: '3.9', text: 'Is the stockpile free from any active fire or smouldering within a 15 m radius?'),
//         StockpileQuestion(code: '3.10', text: 'Is storage of inflammable materials (grease, oil, fuel) at least 15 m from stockpile area entrances?'),
//       ],
//     ),
//     StockpileSection(
//       title: 'Fencing, Barriers & Access Control',
//       questions: [
//         StockpileQuestion(code: '4.1', text: 'Is a suitable fence erected between the stockpile toe and any adjacent railway, public road, or structure not belonging to the owner?'),
//         StockpileQuestion(code: '4.2', text: 'Are unauthorised persons effectively prevented from approaching?'),
//         StockpileQuestion(code: '4.3', text: 'Are barricades or berms adequate at edges of haul roads adjacent to the stockpile?'),
//         StockpileQuestion(code: '4.4', text: 'Are danger/warning signboards clearly displayed at all entry points of the stockpile area?'),
//         StockpileQuestion(code: '4.5', text: 'Is access to the active face of the stockpile controlled?'),
//       ],
//     ),
//     StockpileSection(
//       title: 'Haul Roads & Traffic Management',
//       questions: [
//         StockpileQuestion(code: '5.1', text: 'Are haul roads to/from the stockpile designed and maintained per Chief Inspector\'s standards, including parapet walls/berms at elevated edges?'),
//         StockpileQuestion(code: '5.2', text: 'Is the haul road surface free from potholes, loose material, or conditions causing vehicle instability?'),
//         StockpileQuestion(code: '5.3', text: 'Are speed limits, directional signs, and traffic control measures in place and enforced?'),
//         StockpileQuestion(code: '5.4', text: 'Is road width adequate for safe movement of dumpers/trucks per mine transport rules?'),
//         StockpileQuestion(code: '5.5', text: 'Is no material placed or dumped within 1.2 m of any rail track in the stockpile area?'),
//         StockpileQuestion(code: '5.6', text: 'Is adequate lighting provided at haul road junctions and active areas of the stockpile?'),
//       ],
//     ),
//     StockpileSection(
//       title: 'Drainage & Environmental Controls',
//       questions: [
//         StockpileQuestion(code: '6.1', text: 'Is drainage around the stockpile adequate to prevent water accumulation that could destabilise the structure?'),
//         StockpileQuestion(code: '6.2', text: 'Is the stockpile base free from any evidence of water seepage?'),
//         StockpileQuestion(code: '6.3', text: 'Are dust suppression measures (water sprinklers, windbreaks) in place and operational?'),
//         StockpileQuestion(code: '6.4', text: 'Is top soil being stacked separately at a designated place for later reclamation use?'),
//         StockpileQuestion(code: '6.5', text: 'Is the stockpile area free from wild or herbaceous plants and dry vegetation that may cause fire risk?'),
//       ],
//     ),
//     StockpileSection(
//       title: 'Periodic Inspection & Record Keeping',
//       questions: [
//         StockpileQuestion(code: '7.1', text: 'Has a competent person inspected the stockpile at least once in every seven days for fire, heating, or slope issues?'),
//         StockpileQuestion(code: '7.2', text: 'Is a record of every such inspection maintained in a bound paged book, duly signed and dated?'),
//         StockpileQuestion(code: '7.3', text: 'Is the sirdar conducting inspection of the dump area every shift?'),
//         StockpileQuestion(code: '7.4', text: 'Are results of stockpile inspections recorded in the shift report book in the prescribed format?'),
//         StockpileQuestion(code: '7.5', text: 'Are defects from previous inspections closed out with evidence of corrective action?'),
//       ],
//     ),
//     StockpileSection(
//       title: 'Personal Protective Equipment & Safety',
//       questions: [
//         StockpileQuestion(code: '8.1', text: 'Are all persons working at or near the stockpile wearing appropriate PPE (hard hat, safety boots, high-vis vest, dust mask)?'),
//         StockpileQuestion(code: '8.2', text: 'Is the inspecting person equipped with appropriate instruments for CO gas detection if required?'),
//         StockpileQuestion(code: '8.3', text: 'Are workers trained on emergency evacuation in the event of stockpile slope failure or fire?'),
//         StockpileQuestion(code: '8.4', text: 'Are first aid facilities and communication systems accessible at the stockpile area?'),
//         StockpileQuestion(code: '8.5', text: 'Is heated material or ash prevented from being deposited on or near the stockpile?'),
//       ],
//     ),
//     StockpileSection(
//       title: 'Machinery & Equipment at Stockpile',
//       questions: [
//         StockpileQuestion(code: '9.1', text: 'Are all heavy earth moving machines (dozers, shovels) at the stockpile operated by authorised persons only?'),
//         StockpileQuestion(code: '9.2', text: 'Is a pre-shift inspection of trucks, dumpers, and tippers done and recorded before operation?'),
//         StockpileQuestion(code: '9.3', text: 'Are dumpers giving audible warning before reversing and reversing only when the area behind is clear?'),
//         StockpileQuestion(code: '9.4', text: 'Is machinery at the stockpile area following the mine\'s code of practice for those machines?'),
//         StockpileQuestion(code: '9.5', text: 'Is no person standing within the tipping/dumping zone when material is being discharged?'),
//       ],
//     ),
//   ];
// }


enum StockpileQuestionType { yesNo, text, dropdown, datepicker }

class StockpileQuestion {
  final String code;
  final String text;
  final StockpileQuestionType type;
  final String? hint;
  final List<String>? options;

  const StockpileQuestion({
    required this.code,
    required this.text,
    this.type = StockpileQuestionType.yesNo,
    this.hint,
    this.options,
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
          type: StockpileQuestionType.dropdown,
          options: [
            'ROM Coal',
            'Clean Coal',
            'Middlings',
            'Reject',
            'Fines',
            'Other',
          ],
        ),
        StockpileQuestion(
          code: '1.2',
          text: 'Approx. stockpile quantity (in tonnes)',
          type: StockpileQuestionType.text,
          hint: 'Enter quantity in tonnes',
        ),
        StockpileQuestion(
          code: '1.3',
          text: 'Average stockpile height (in metres)',
          type: StockpileQuestionType.text,
          hint: 'Enter height in metres',
        ),
        StockpileQuestion(
          code: '1.4',
          text: 'Approx. stockpile floor area (in square metres)',
          type: StockpileQuestionType.text,
          hint: 'Enter area in square metres',
        ),
        StockpileQuestion(
          code: '1.5',
          text: 'Approx. age of stockpile (in months)',
          type: StockpileQuestionType.text,
          hint: 'e.g. 3 months',
        ),
        StockpileQuestion(
          code: '1.6',
          text: 'Last dozing / reshaping date',
          type: StockpileQuestionType.datepicker,
        ),
        StockpileQuestion(
          code: '1.7',
          text: 'Last temperature monitoring date',
          type: StockpileQuestionType.datepicker,
        ),
        StockpileQuestion(
          code: '1.8',
          text: 'Last firefighting / spraying date',
          type: StockpileQuestionType.datepicker,
        ),
      ],
    ),
    StockpileSection(
      title: 'Stockpile Structure & Slope Stability',
      questions: [
        StockpileQuestion(code: '2.1', text: 'Is the slope angle within permissible limit (≤37.5° from horizontal, unless scientifically justified and permitted)?'),
        StockpileQuestion(code: '2.2', text: 'For stockpiles exceeding 30 m in height, has benching been done with each bench not exceeding 30 m and overall slope not more than 1V:1.5H?'),
        StockpileQuestion(code: '2.3', text: 'Is the stockpile face free from any evidence of slope failure?'),
        StockpileQuestion(code: '2.4', text: 'Has overburden or loose material been dumped in a manner that eliminates risk of sliding?'),
        StockpileQuestion(code: '2.5', text: 'Is the stockpile toe at least 100 m from any mine opening, railway, public road, or permanent structure not owned by mine owner?'),
        StockpileQuestion(code: '2.6', text: 'Whether slope stability monitoring study carried out by any scientific agency?'),
        StockpileQuestion(code: '2.7', text: 'Whether any slope monitoring record maintained in this mine? If yes, then please enter whether slope monitoring records are up to date?'),
      ],
    ),
    StockpileSection(
      title: 'Spontaneous Heating & Fire Prevention',
      questions: [
        StockpileQuestion(code: '3.1', text: 'Is the stockpile free from any visible signs of smoke?'),
        StockpileQuestion(code: '3.2', text: 'What is the visible extent of smoke effect area? (High/Medium/Low)'),
        StockpileQuestion(code: '3.3', text: 'Whether a standard method of temperature monitoring of the stockpile maintained?'),
        StockpileQuestion(code: '3.4', text: 'Whether the monitored stockpile temperatures are within the prescribed threshold limits?'),
        StockpileQuestion(code: '3.5', text: 'What is the current average temperature of the stockpile? (in °C)'),
        StockpileQuestion(code: '3.6', text: 'Is temperature monitoring being carried out at the stockpile for early detection of heating?'),
        StockpileQuestion(code: '3.7', text: 'Is carbonaceous shale stored separately and not mixed with the coal stockpile?'),
        StockpileQuestion(code: '3.8', text: 'Whether the stockpile needs currently water spraying for fire prevention?'),
        StockpileQuestion(code: '3.9', text: 'Are dead leaves, dry vegetation and combustible waste cleared from around the stockpile?'),
        StockpileQuestion(code: '3.10', text: 'Is there adequate water supply at sufficient pressure available at the stockpile for fire-fighting purposes?'),
        StockpileQuestion(code: '3.11', text: 'Are portable fire extinguishers or sand/incombustible material provided at stockpile access points?'),
        StockpileQuestion(code: '3.12', text: 'Is the stockpile free from any active fire or smouldering within a 15 m radius?'),
        StockpileQuestion(code: '3.13', text: 'Is storage of inflammable materials (grease, oil, fuel) at least 15 m from stockpile area entrances?'),
      ],
    ),
    StockpileSection(
      title: 'Fencing, Barriers & Access Control',
      questions: [
        StockpileQuestion(code: '4.1', text: 'Is a suitable fence erected between the stockpile toe and any adjacent railway, public road, or structure not belonging to the owner?'),
        StockpileQuestion(code: '4.2', text: 'Are unauthorised persons effectively prevented from approaching?'),
        StockpileQuestion(code: '4.3', text: 'Are barricades or berms adequate at edges of haul roads adjacent to the stockpile?'),
        StockpileQuestion(code: '4.4', text: 'Are danger/warning signboards clearly visible and properly installed at all entry points and strategic locations around the stockpile area?'),
        StockpileQuestion(code: '4.5', text: 'Is access to the active face of the stockpile controlled?'),
      ],
    ),
    StockpileSection(
      title: 'Haul Roads & Traffic Management',
      questions: [
        StockpileQuestion(code: '5.1', text: 'Are haul roads to/from the stockpile designed and maintained per statue, including parapet walls/berms at elevated edges?'),
        StockpileQuestion(code: '5.2', text: 'Is the haul road surface free from potholes, loose material, or conditions causing vehicle instability?'),
        StockpileQuestion(code: '5.3', text: 'Are speed limits, directional signs, and traffic control measures in place and enforced?'),
        StockpileQuestion(code: '5.4', text: 'Is road width adequate for safe movement of dumpers/trucks as per statue?'),
        StockpileQuestion(code: '5.5', text: 'A minimum clearance of 1.2 m is maintained between stored/dumped material and any rail track in the stockpile area.'),
        StockpileQuestion(code: '5.6', text: 'Is adequate lighting provided at haul road junctions and active areas of the stockpile?'),
      ],
    ),
    StockpileSection(
      title: 'Drainage & Environmental Controls',
      questions: [
        StockpileQuestion(code: '6.1', text: 'Is drainage around the stockpile adequate to prevent water accumulation that could destabilise the structure?'),
        StockpileQuestion(code: '6.2', text: 'Is the stockpile base free from any evidence of water seepage?'),
        StockpileQuestion(code: '6.3', text: 'Are dust suppression measures (water sprinklers, windbreaks) in place and operational?'),
        StockpileQuestion(code: '6.4', text: 'Is top soil being stacked separately at a designated place for later reclamation use?'),
        StockpileQuestion(code: '6.5', text: 'Is the stockpile area free from wild or herbaceous plants and dry vegetation that may cause fire risk?'),
      ],
    ),
    StockpileSection(
      title: 'Periodic Inspection & Record Keeping',
      questions: [
        StockpileQuestion(code: '7.1', text: 'Has a competent person inspected the stockpile at least once in every seven days for fire, heating, or slope issues?'),
        StockpileQuestion(code: '7.2', text: 'Is a record of every such inspection maintained in a bound paged book, duly signed and dated?'),
        StockpileQuestion(code: '7.3', text: 'Is the sirdar conducting inspection of the dump area every shift?'),
        StockpileQuestion(code: '7.4', text: 'The dump area is inspected by the Overman during every shift?'),
        StockpileQuestion(code: '7.5', text: 'Are results of stockpile inspections recorded in the shift report book in the prescribed format?'),
        StockpileQuestion(code: '7.6', text: 'Are defects from previous inspections closed out with evidence of corrective action?'),
      ],
    ),
    StockpileSection(
      title: 'Personal Protective Equipment & Safety',
      questions: [
        StockpileQuestion(code: '8.1', text: 'Are all persons working at or near the stockpile wearing appropriate PPE (hard hat, safety boots, high-vis vest, dust mask)?'),
        StockpileQuestion(code: '8.2', text: 'Is the inspecting person equipped with appropriate instruments for CO gas detection if required?'),
        StockpileQuestion(code: '8.3', text: 'Are workers trained on emergency evacuation in the event of stockpile slope failure or fire?'),
        StockpileQuestion(code: '8.4', text: 'Are first aid facilities and communication systems accessible at the stockpile area?'),
        StockpileQuestion(code: '8.5', text: 'Is heated material or ash prevented from being deposited on or near the stockpile?'),
      ],
    ),
    StockpileSection(
      title: 'Machinery & Equipment at Stockpile',
      questions: [
        StockpileQuestion(code: '9.1', text: 'Are all heavy earth moving machines (dozers, shovels) at the stockpile operated by authorised persons only?'),
        StockpileQuestion(code: '9.2', text: 'Is a pre-shift inspection of dumper/tippers/trucks done and recorded before operation?'),
        StockpileQuestion(code: '9.3', text: 'Are dumper/tippers/trucks giving audible warning before reversing?'),
        StockpileQuestion(code: '9.4', text: 'Whether the standard code of practice is being followed for each machine operating in the stockpile area?'),
        StockpileQuestion(code: '9.5', text: 'Whether the tipping/dumping zone is clear of personnel during material discharge?'),
      ],
    ),
  ];
}