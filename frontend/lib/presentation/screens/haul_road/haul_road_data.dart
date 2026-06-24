// lib/presentation/screens/haul_road/haul_road_data.dart

import 'package:mine_wadhwani/presentation/screens/common/inspection_section.dart';

class HaulRoadData {
  static const List<InspectionSection> sections = [
    InspectionSection(
      title: 'Road Geometry & Width Compliance (Reg. 100)',
      questions: [
        InspectionQuestion(
          code: 'Q1.1',
          text:
              'Is the total width of the haul road (excluding parapet walls/bunds) at least three times the width of the largest dumper plying on it plus an additional 3 meters for safe clearance?',
        ),
        InspectionQuestion(
          code: 'Q1.2',
          text:
              'On single-lane sections or ramps with a designated traffic priority, is the road width at least twice the width of the largest dumper?',
        ),
        InspectionQuestion(
          code: 'Q1.3',
          text:
              'Are all sharp curves properly designed with adequate super-elevation (banking) to prevent heavy machinery from skidding or tipping over?',
        ),
        InspectionQuestion(
          code: 'Q1.4',
          text:
              'Is the horizontal visibility at all curves sufficient for the largest vehicle to come to a complete stop safely at maximum permissible speed?',
        ),
      ],
    ),
    InspectionSection(
      title: 'Gradient & Surface Conditions',
      questions: [
        InspectionQuestion(
          code: 'Q2.1',
          text:
              'Is the longitudinal gradient of the haul road maintained within the permissible 1 in 16 (or flatter) limit throughout the entire route?',
        ),
        InspectionQuestion(
          code: 'Q2.2',
          text:
              'Is the road surface structurally sound and free from severe potholes, ruts, deep corrugated ripples, and large loose boulders?',
        ),
        InspectionQuestion(
          code: 'Q2.3',
          text:
              'Is a cross-fall or camber properly maintained to ensure rainwater drains away from the road surface instead of pooling?',
        ),
        InspectionQuestion(
          code: 'Q2.4',
          text:
              'Are any concrete or paved sections free from structural cracks and major surface subsidence?',
        ),
      ],
    ),
    InspectionSection(
      title: 'Safety Berms, Embankments & Bunds',
      questions: [
        InspectionQuestion(
          code: 'Q3.1',
          text:
              'Wherever the road runs along the edge of a spoil-bank or bench, is a strong safety berm (bund) constructed along the exposed edge?',
        ),
        InspectionQuestion(
          code: 'Q3.2',
          text:
              'Is the height of the safety berm at least equal to the radius (half-height) of the largest tire among the vehicles plying on the road?',
        ),
        InspectionQuestion(
          code: 'Q3.3',
          text:
              'Is the base of the safety berm sufficiently wide and compacted to withstand the impact of a drifting or runaway dumper?',
        ),
        InspectionQuestion(
          code: 'Q3.4',
          text:
              'Are there clear escape cut-outs or drainage channels integrated into the berm without compromising its structural safety?',
        ),
      ],
    ),
    InspectionSection(
      title: 'Traffic Control, Signage & Visibility',
      questions: [
        InspectionQuestion(
          code: 'Q4.1',
          text:
              'Are standard DGMS traffic signs (Speed Limits, Keep Left, Caution Curves, Steep Gradient) clearly posted and highly legible?',
        ),
        InspectionQuestion(
          code: 'Q4.2',
          text:
              'Are all traffic signs made of high-intensity reflective material to ensure they remain clearly visible during night shifts?',
        ),
        InspectionQuestion(
          code: 'Q4.3',
          text:
              'Is the haul road entirely separate from pedestrian walkways or light vehicle paths where feasible?',
        ),
        InspectionQuestion(
          code: 'Q4.4',
          text:
              'Are clear intersection priority rules established, clearly marked, and known to all operators?',
        ),
      ],
    ),
    InspectionSection(
      title: 'Environmental Controls (Dust & Illumination)',
      questions: [
        InspectionQuestion(
          code: 'Q5.1',
          text:
              'Is regular water sprinkling carried out on the haul road to suppress dust and maintain clear operator visibility?',
        ),
        InspectionQuestion(
          code: 'Q5.2',
          text:
              'Is the road surface damp enough to suppress dust without becoming slushy, slippery, or dangerous for heavy tires?',
        ),
        InspectionQuestion(
          code: 'Q5.3',
          text:
              'For night operations, is fixed lighting provided at all major intersections, sharp curves, and dumping points with a minimum illumination level of 10 lux?',
        ),
        InspectionQuestion(
          code: 'Q5.4',
          text:
              'Are drainage drains along the sides of the haul road completely clear of debris, allowing free flow of water away from the foundation?',
        ),
      ],
    ),
    InspectionSection(
      title: 'Emergency Infrastructure & Dumping Points',
      questions: [
        InspectionQuestion(
          code: 'Q6.1',
          text:
              'Are escape ramps or runaway sand-benches available and clearly marked on steep downward slopes to catch vehicles with brake failures?',
        ),
        InspectionQuestion(
          code: 'Q6.2',
          text:
              'At the edge of the active dump point, is a substantial bumper block or strong earthen backstop provided to prevent dumpers from reversing over the edge?',
        ),
        InspectionQuestion(
          code: 'Q6.3',
          text:
              'Are there designated, level, and stable breakdown parking bays located completely away from the active traffic lanes?',
        ),
      ],
    ),
  ];
}