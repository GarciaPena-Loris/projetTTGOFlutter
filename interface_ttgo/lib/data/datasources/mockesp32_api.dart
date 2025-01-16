class MockESP32Api {
  Future<Map<String, dynamic>> getSensorData() async {
    print('Appel de getSensorData');
    return {
      'light': 2.5, // Valeur fictive de la lumière en volts
      'temperature': 22.0, // Valeur fictive de la température en degrés Celsius
    };
  }

  Future<bool> setLedState(String led, bool state) async {
    print('Appel de setLedState avec led: $led, state: $state');
    return true;
  }

  Future<bool> setMode(String mode, bool state, double threshold) async {
    print('Appel de setMode avec mode: $mode, state: $state, threshold: $threshold');
    return true;
  }

  Future<bool> playMelody(int melodyIndex) async {
    print('Appel de playMelody avec melodyIndex: $melodyIndex');
    return true;
  }

  Future<bool> setAlarm(int hour, int minute, int melodyIndex) async {
    print('Appel de setAlarm avec hour: $hour, minute: $minute, melodyIndex: $melodyIndex');
    return true;
  }

  Future<String> getLedState(String led) async {
    print('Appel de getLedState avec led: $led');
    // Retourner un état fictif pour la LED
    return 'on';
  }
}