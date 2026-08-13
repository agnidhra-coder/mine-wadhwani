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
  // Defaults based on general OSHA/NIOSH/clinical guidance.
  // TODO: confirm against local mining safety regulation (e.g. DGMS) and adjust.
  static const double minHeartRate = 50;
  static const double maxHeartRate = 140;
  static const double minSpo2 = 90;
  static const double maxPm25 = 100; // µg/m³
  static const double maxCo = 50; // ppm
  static const double maxDust = 5; // mg/m³ (respirable)
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
    final dust = double.tryParse(aqmReadings['Dust Level (mg/m³)'] ?? '');
    if (pm25 != null && pm25 > HealthThresholds.maxPm25) return true;
    if (co != null && co > HealthThresholds.maxCo) return true;
    if (dust != null && dust > HealthThresholds.maxDust) return true;
    return false;
  }

  int get flagCount {
    int count = 0;
    if (aqmFlagged) count++;
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