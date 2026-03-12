class HazardEntry {
  final String subActivity;
  final String hazard;
  final String mechanism;
  final String control;
  final String references;

  const HazardEntry({
    required this.subActivity,
    required this.hazard,
    required this.mechanism,
    required this.control,
    required this.references,
  });

  factory HazardEntry.fromJson(Map<String, dynamic> json) {
    return HazardEntry(
      subActivity: json['subActivity'] as String? ?? '',
      hazard: json['hazard'] as String? ?? '',
      mechanism: json['mechanism'] as String? ?? '',
      control: json['control'] as String? ?? '',
      references: json['references'] as String? ?? '',
    );
  }
}
