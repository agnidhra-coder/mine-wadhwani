class AqmReading {
  final double pm25;
  final double pm10;
  final double pm1;
  final double tvoc;
  final double co;
  final double co2;
  final double h2s;
  final double methane;
  final double temperature;
  final double humidity;
  final int noise;
  final int aqiUs;
  final DateTime fetchedAt;

  const AqmReading({
    required this.pm25,
    required this.pm10,
    required this.pm1,
    required this.tvoc,
    required this.co,
    required this.co2,
    required this.h2s,
    required this.methane,
    required this.temperature,
    required this.humidity,
    required this.noise,
    required this.aqiUs,
    required this.fetchedAt,
  });

  factory AqmReading.fromJson(Map<String, dynamic> json) {
    return AqmReading(
      pm25: (json['pm25'] as num).toDouble(),
      pm10: (json['pm10'] as num).toDouble(),
      pm1: (json['pm1'] as num).toDouble(),
      tvoc: (json['tvoc'] as num).toDouble(),
      co: (json['co'] as num).toDouble(),
      co2: (json['co2'] as num).toDouble(),
      h2s: (json['h2s'] as num).toDouble(),
      methane: (json['methane'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      noise: json['noise'] as int,
      aqiUs: json['aqiUs'] as int,
      fetchedAt: DateTime.now(),
    );
  }
}