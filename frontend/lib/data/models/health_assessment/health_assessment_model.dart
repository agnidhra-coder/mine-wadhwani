// class HealthAssessmentModel {
//   final bool conducted;
//   final String zone;
//   final List<String> modes; // e.g. ['AQM', 'Drone', 'Smartwatch']
//   final Map<String, String> readings; // e.g. {'PM2.5': '120 µg/m³', 'CO': '3 ppm'}
//   final String notes;
//   final DateTime assessedAt;

//   const HealthAssessmentModel({
//     required this.conducted,
//     required this.zone,
//     required this.modes,
//     required this.readings,
//     required this.notes,
//     required this.assessedAt,
//   });

//   factory HealthAssessmentModel.skipped() => HealthAssessmentModel(
//         conducted: false,
//         zone: '',
//         modes: const [],
//         readings: const {},
//         notes: '',
//         assessedAt: DateTime.now(),
//       );

//   Map<String, dynamic> toJson() => {
//         'conducted': conducted,
//         'zone': zone,
//         'modes': modes,
//         'readings': readings,
//         'notes': notes,
//         'assessedAt': assessedAt.toIso8601String(),
//       };

//   factory HealthAssessmentModel.fromJson(Map<String, dynamic> json) {
//     return HealthAssessmentModel(
//       conducted: json['conducted'] as bool? ?? false,
//       zone: json['zone'] as String? ?? '',
//       modes: (json['modes'] as List?)?.map((e) => e.toString()).toList() ?? [],
//       readings: (json['readings'] as Map?)?.map(
//             (k, v) => MapEntry(k.toString(), v.toString()),
//           ) ??
//           {},
//       notes: json['notes'] as String? ?? '',
//       assessedAt: DateTime.tryParse(json['assessedAt'] as String? ?? '') ??
//           DateTime.now(),
//     );
//   }
// }

class HealthThresholds {
  // General thresholds
  static const double minHeartRate = 50;
  static const double maxHeartRate = 140;
  static const double minSpo2 = 90;

  // Gas limits — DGMS Coal Mines Regulations (TLV/MAC values)
  static const double maxCo = 50; // ppm — DGMS TLV
  static const double maxCo2 = 5000; // ppm (0.5%) — DGMS TLV
  static const double maxH2s = 5; // ppm (0.0005%) — DGMS TLV
  static const double maxMethane = 0.75; // % — DGMS limit, general body of return air

  // Environmental — standard occupational/industrial hygiene references,
  // not DGMS-specific. Verify against DGMS Coal Mines Regulations directly
  // if this moves beyond a college project.
  static const double maxPm25 = 100; // µg/m³
  static const double maxNoise = 90; // dB (8-hr occupational exposure)
  static const double maxTemperature = 35; // °C

  static const double minPpeCompliancePercent = 80; // flag if below 80%
}

class WorkerReading {
  final String name;
  final String heartRate;
  final String spo2;

  const WorkerReading({
    required this.name,
    required this.heartRate,
    required this.spo2,
  });

  bool get heartRateFlagged {
    final hr = double.tryParse(heartRate);
    if (hr == null) return false;
    return hr < HealthThresholds.minHeartRate || hr > HealthThresholds.maxHeartRate;
  }

  bool get spo2Flagged {
    final s = double.tryParse(spo2);
    if (s == null) return false;
    return s < HealthThresholds.minSpo2;
  }

  bool get isFlagged => heartRateFlagged || spo2Flagged;

  Map<String, dynamic> toJson() => {
        'name': name,
        'heartRate': heartRate,
        'spo2': spo2,
      };

  factory WorkerReading.fromJson(Map<String, dynamic> json) => WorkerReading(
        name: json['name'] as String? ?? '',
        heartRate: json['heartRate'] as String? ?? '',
        spo2: json['spo2'] as String? ?? '',
      );
}

class HealthAssessmentModel {
  final bool conducted;
  final String zone;
  final List<String> modes; // e.g. ['AQM', 'Drone', 'Smartwatch']
  final Map<String, String> aqmReadings; // PM2.5, CO, Dust Level
  final Map<String, String> droneReadings; // Thermal Flag, PPE Compliance, Observation
  final List<WorkerReading> workerReadings; // one entry per worker checked
  final String notes;
  final DateTime assessedAt;

  const HealthAssessmentModel({
    required this.conducted,
    required this.zone,
    required this.modes,
    required this.aqmReadings,
    required this.droneReadings,
    required this.workerReadings,
    required this.notes,
    required this.assessedAt,
  });

  factory HealthAssessmentModel.skipped() => HealthAssessmentModel(
        conducted: false,
        zone: '',
        modes: const [],
        aqmReadings: const {},
        droneReadings: const {},
        workerReadings: const [],
        notes: '',
        assessedAt: DateTime.now(),
      );

  bool get aqmFlagged {
    final pm25 = double.tryParse(aqmReadings['PM2.5 (µg/m³)'] ?? '');
    final co = double.tryParse(aqmReadings['CO (ppm)'] ?? '');
    final co2 = double.tryParse(aqmReadings['CO2 (ppm)'] ?? '');
    final h2s = double.tryParse(aqmReadings['H2S (ppm)'] ?? '');
    final methane = double.tryParse(aqmReadings['Methane (%)'] ?? '');
    final temp = double.tryParse(aqmReadings['Temperature (°C)'] ?? '');
    final noise = double.tryParse(aqmReadings['Noise (dB)'] ?? '');
    if (pm25 != null && pm25 > HealthThresholds.maxPm25) return true;
    if (co != null && co > HealthThresholds.maxCo) return true;
    if (co2 != null && co2 > HealthThresholds.maxCo2) return true;
    if (h2s != null && h2s > HealthThresholds.maxH2s) return true;
    if (methane != null && methane > HealthThresholds.maxMethane) return true;
    if (temp != null && temp > HealthThresholds.maxTemperature) return true;
    if (noise != null && noise > HealthThresholds.maxNoise) return true;
    return false;
  }
  
  bool get droneFlagged {
    final ppe = double.tryParse(droneReadings['PPE Compliance (%)'] ?? '');
    final hazards = droneReadings['Hazard Tags'] ?? '';
    if (ppe != null && ppe < HealthThresholds.minPpeCompliancePercent) return true;
    if (hazards.isNotEmpty) return true;
    return false;
  }

  int get flagCount {
    int count = 0;
    if (aqmFlagged) count++;
    if (droneFlagged) count++;
    count += workerReadings.where((w) => w.isFlagged).length;
    return count;
  }

  bool get hasFlags => flagCount > 0;

  Map<String, dynamic> toJson() => {
        'conducted': conducted,
        'zone': zone,
        'modes': modes,
        'aqmReadings': aqmReadings,
        'droneReadings': droneReadings,
        'workerReadings': workerReadings.map((w) => w.toJson()).toList(),
        'notes': notes,
        'assessedAt': assessedAt.toIso8601String(),
      };

  factory HealthAssessmentModel.fromJson(Map<String, dynamic> json) {
    return HealthAssessmentModel(
      conducted: json['conducted'] as bool? ?? false,
      zone: json['zone'] as String? ?? '',
      modes: (json['modes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      aqmReadings: (json['aqmReadings'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v.toString()),
          ) ??
          {},
      droneReadings: (json['droneReadings'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v.toString()),
          ) ??
          {},
      workerReadings: (json['workerReadings'] as List?)
              ?.map((e) => WorkerReading.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'] as String? ?? '',
      assessedAt: DateTime.tryParse(json['assessedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}