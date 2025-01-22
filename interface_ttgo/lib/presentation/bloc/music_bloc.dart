import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/esp32_api.dart';
import '../../data/datasources/mockesp32_api.dart';

abstract class MusicEvent {}

class PlayMelody extends MusicEvent {
  final int melodyIndex;
  final String melodyName;
  PlayMelody(this.melodyIndex, this.melodyName);
}

class SetAlarm extends MusicEvent {
  final int hour;
  final int minute;
  final int melodyIndex;
  SetAlarm({required this.hour, required this.minute, required this.melodyIndex});
}

abstract class MusicState {}

class MusicInitial extends MusicState {}

class MusicPlaying extends MusicState {
  final String message;
  MusicPlaying(this.message);
}

class AlarmSet extends MusicState {
  final String message;
  AlarmSet(this.message);
}

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final ESP32Api _api = ESP32Api();

  MusicBloc() : super(MusicInitial()) {
    on<PlayMelody>((event, emit) async {
      final success = await _api.playMelody(event.melodyIndex);
      if (success) {
        emit(MusicPlaying("La mélodie '${event.melodyName}' est en train de se jouer"));
      }
    });

    on<SetAlarm>((event, emit) async {
      final success = await _api.setAlarm(event.hour, event.minute, event.melodyIndex);
      if (success) {
        emit(AlarmSet("Alarme définie avec succès"));
      }
    });
  }
}