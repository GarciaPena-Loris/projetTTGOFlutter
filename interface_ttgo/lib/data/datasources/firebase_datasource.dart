import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/sensor_data.dart';

class FirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SensorData>> getSensorDataInRange(DateTime start, DateTime end) async {
    print('Appel de getSensorDataInRange avec start: $start et end: $end');
    final snapshot = await _firestore
        .collection('sensor_data')
        .where('timestamp', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('timestamp', isLessThanOrEqualTo: end.toIso8601String())
        .orderBy('timestamp')
        .get();

    final data = snapshot.docs.map((doc) {
      final data = doc.data();
      return SensorData(
        temperature: data['temperature'],
        light: data['light'],
        timestamp: DateTime.parse(data['timestamp']),
      );
    }).toList();

    print('Données retournées: $data');
    return data;
  }

  Future<void> saveSensorData(SensorData data) async {
    print('Appel de saveSensorData avec data: $data');
    await _firestore.collection('sensor_data').add({
      'temperature': data.temperature,
      'light': data.light,
      'timestamp': data.timestamp.toIso8601String(),
    });
    print('Données sauvegardées');
  }

  Stream<List<SensorData>> getSensorDataStream() {
    print('Appel de getSensorDataStream');
    return _firestore
        .collection('sensor_data')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.docs.map((doc) {
        final data = doc.data();
        return SensorData(
          temperature: data['temperature'],
          light: data['light'],
          timestamp: DateTime.parse(data['timestamp']),
        );
      }).toList();
      print('Données du stream: $data');
      return data;
    });
  }
}