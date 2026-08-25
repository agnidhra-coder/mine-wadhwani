import 'dart:math';
import 'package:mine_wadhwani/data/models/aqm_reading.dart';

abstract class AqmDataSource {
  Future<AqmReading> fetchLatestReading();
}

class MockAqmDataSource implements AqmDataSource {
  final _random = Random();

  @override
  Future<AqmReading> fetchLatestReading() async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (_random.nextDouble() < 0.1) {
      throw AqmFetchException('AQM device unreachable. Check connection.');
    }

    return AqmReading.fromJson({
      'pm25': 30 + _random.nextInt(20),
      'pm10': 35 + _random.nextInt(20),
      'pm1': 20 + _random.nextInt(15),
      'tvoc': 0.05 + _random.nextDouble() * 0.15,
      'co': 1.0 + _random.nextDouble() * 1.5,
      'co2': 500 + _random.nextInt(150),
      'h2s': _random.nextDouble() * 0.01,
      'methane': _random.nextDouble() * 0.1,
      'temperature': 28 + _random.nextDouble() * 6,
      'humidity': 55 + _random.nextInt(20),
      'noise': 40 + _random.nextInt(75), // occasionally spikes past 90dB for testing
      'aqiUs': 90 + _random.nextInt(40),
    });
  }
}

class AqmFetchException implements Exception {
  final String message;
  AqmFetchException(this.message);
  @override
  String toString() => message;
}