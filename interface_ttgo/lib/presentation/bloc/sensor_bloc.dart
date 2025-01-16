import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/esp32_api.dart';
import '../../data/datasources/firebase_datasource.dart';
import '../../data/datasources/mockesp32_api.dart';
import '../../data/entities/sensor_data.dart';

enum VisualizationType { text, gauge, json }

// Events
abstract class SensorEvent {}

class FetchSensorData extends SensorEvent {}
class ChangeVisualization extends SensorEvent {
  final VisualizationType type;
  ChangeVisualization(this.type);
}

// States
abstract class SensorState {}

class SensorInitial extends SensorState {}
class SensorLoading extends SensorState {}
class SensorDataLoaded extends SensorState {
  final SensorData data;
  final VisualizationType visualizationType;
  SensorDataLoaded(this.data, this.visualizationType);
}
class SensorError extends SensorState {
  final String message;
  SensorError(this.message);
}

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  final MockESP32Api _esp32Api; // Mocked
  final FirebaseDataSource _firebaseDataSource;
  VisualizationType _currentVisualization = VisualizationType.text;

  SensorBloc(this._esp32Api, this._firebaseDataSource) : super(SensorInitial()) {
    on<FetchSensorData>(_onFetchSensorData);
    on<ChangeVisualization>(_onChangeVisualization);

    // Démarrer la collecte périodique des données
    _startPeriodicDataCollection();
  }

  void _startPeriodicDataCollection() {
    Timer.periodic(Duration(minutes: 1), (timer) async {
      try {
        final data = await _esp32Api.getSensorData();
        final sensorData = SensorData(
          temperature: data['temperature'],
          light: data['light'],
          timestamp: DateTime.now(),
        );
        await _firebaseDataSource.saveSensorData(sensorData);
      } catch (e) {
        print('Error collecting data: $e');
      }
    });
  }

  Future<void> _onFetchSensorData(
      FetchSensorData event,
      Emitter<SensorState> emit,
      ) async {
    try {
      emit(SensorLoading());
      final data = await _esp32Api.getSensorData();
      final sensorData = SensorData(
        temperature: data['temperature'],
        light: data['light'],
        timestamp: DateTime.now(),
      );
      emit(SensorDataLoaded(sensorData, _currentVisualization));
    } catch (e) {
      emit(SensorError(e.toString()));
    }
  }

  void _onChangeVisualization(
      ChangeVisualization event,
      Emitter<SensorState> emit,
      ) {
    _currentVisualization = event.type;
    if (state is SensorDataLoaded) {
      emit(SensorDataLoaded((state as SensorDataLoaded).data, _currentVisualization));
    }
  }
}