class Detection {
  final String label;
  final double confidence;
  final double x;
  final double y;
  final double width;
  final double height;

  const Detection({
    required this.label,
    required this.confidence,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      label: (json['class'] as String?) ?? 'unknown',
      confidence: ((json['confidence'] as num?) ?? 0).toDouble(),
      x: ((json['x'] as num?) ?? 0).toDouble(),
      y: ((json['y'] as num?) ?? 0).toDouble(),
      width: ((json['width'] as num?) ?? 0).toDouble(),
      height: ((json['height'] as num?) ?? 0).toDouble(),
    );
  }
}

class DroneAnalysisResult {
  final int workersDetected;
  final int workersWithPpe;
  final List<String> hazardTags;
  final double confidenceScore;
  final DateTime analyzedAt;
  final List<Detection> detections;
  final double imageWidth;
  final double imageHeight;

  const DroneAnalysisResult({
    required this.workersDetected,
    required this.workersWithPpe,
    required this.hazardTags,
    required this.confidenceScore,
    required this.analyzedAt,
    this.detections = const [],
    this.imageWidth = 0,
    this.imageHeight = 0,
  });

  double get ppeCompliancePercent =>
      workersDetected == 0 ? 100 : (workersWithPpe / workersDetected) * 100;
}