import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/firebase_datasource.dart';
import '../../data/entities/sensor_data.dart';

enum TimeRange { hour, day, week, month }

abstract class StatisticsEvent {}

class LoadStatistics extends StatisticsEvent {
  final TimeRange timeRange;
  LoadStatistics(this.timeRange);
}

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}
class StatisticsLoading extends StatisticsState {}
class StatisticsLoaded extends StatisticsState {
  final List<SensorData> data;
  final TimeRange timeRange;
  StatisticsLoaded(this.data, this.timeRange);
}
class StatisticsError extends StatisticsState {
  final String message;
  StatisticsError(this.message);
}

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final FirebaseDataSource _firebaseDataSource;

  StatisticsBloc(this._firebaseDataSource) : super(StatisticsInitial()) {
    on<LoadStatistics>(_onLoadStatistics);
  }

  Future<void> _onLoadStatistics(
      LoadStatistics event,
      Emitter<StatisticsState> emit,
      ) async {
    try {
      emit(StatisticsLoading());

      DateTime startDate;
      final now = DateTime.now();

      switch (event.timeRange) {
        case TimeRange.hour:
          startDate = now.subtract(Duration(hours: 1));
          break;
        case TimeRange.day:
          startDate = now.subtract(Duration(days: 1));
          break;
        case TimeRange.week:
          startDate = now.subtract(Duration(days: 7));
          break;
        case TimeRange.month:
          startDate = now.subtract(Duration(days: 30));
          break;
      }

      final data = await _firebaseDataSource.getSensorDataInRange(startDate, now);
      emit(StatisticsLoaded(data, event.timeRange));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}