import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/esp32_api.dart';
import '../../data/datasources/mockesp32_api.dart';

abstract class LedControlState {}

class LedControlInitial extends LedControlState {}

class LedControlLoading extends LedControlState {}

class LedControlSuccess extends LedControlState {}

class LedControlError extends LedControlState {
  final String message;
  LedControlError(this.message);
}

abstract class LedControlEvent {}

class SetLedState extends LedControlEvent {
  final String led;
  final bool state;
  SetLedState(this.led, this.state);
}

class SetMode extends LedControlEvent {
  final String mode;
  final bool state;
  final double threshold;
  SetMode(this.mode, this.state, this.threshold);
}

class LedControlBloc extends Bloc<LedControlEvent, LedControlState> {
  final ESP32Api _esp32Api;

  LedControlBloc(this._esp32Api) : super(LedControlInitial()) {
    on<SetLedState>(_onSetLedState);
    on<SetMode>(_onSetMode);
  }

  Future<void> _onSetLedState(
      SetLedState event,
      Emitter<LedControlState> emit,
      ) async {
    try {
      emit(LedControlLoading());
      await _esp32Api.setLedState(event.led, event.state);
      emit(LedControlSuccess());
    } catch (e) {
      emit(LedControlError(e.toString()));
    }
  }

  Future<void> _onSetMode(
      SetMode event,
      Emitter<LedControlState> emit,
      ) async {
    try {
      emit(LedControlLoading());
      await _esp32Api.setMode(event.mode, event.state, event.threshold);
      emit(LedControlSuccess());
    } catch (e) {
      emit(LedControlError(e.toString()));
    }
  }
}