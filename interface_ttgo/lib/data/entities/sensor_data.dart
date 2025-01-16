class SensorData {
  final double temperature;
  final double light;
  final DateTime timestamp;

  SensorData({
    required this.temperature,
    required this.light,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'SensorData(temperature: $temperature, light: $light, timestamp: $timestamp)';
  }
}