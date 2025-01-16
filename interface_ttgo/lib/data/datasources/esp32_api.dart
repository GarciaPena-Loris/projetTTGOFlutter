import 'package:http/http.dart' as http;
import 'dart:convert';

class ESP32Api {
  final String baseUrl = 'http://123.12.12.12';

  Future<Map<String, dynamic>> getSensorData() async {
    final lightResponse = await http.get(Uri.parse('$baseUrl/get/light'));
    final temperatureResponse = await http.get(Uri.parse('$baseUrl/get/temperature'));

    if (lightResponse.statusCode == 200 && temperatureResponse.statusCode == 200) {
      final lightData = json.decode(lightResponse.body);
      final temperatureData = json.decode(temperatureResponse.body);

      return {
        'light': lightData['light'],
        'temperature': temperatureData['temperature'],
      };
    }
    throw Exception('Failed to get sensor data');
  }

  Future<bool> setLedState(String led, bool state) async {
    final response = await http.get(
      Uri.parse('$baseUrl/led/$led?state=$state'),
    );
    if (response.statusCode != 200) throw Exception('Failed to control LED');
    return true;
  }

  Future<bool> setMode(String mode, bool state, double threshold) async {
    final response = await http.post(
      Uri.parse('$baseUrl/control/$mode'),
      body: {
        'state': state.toString(),
        'seuil': threshold.toString(),
      },
    );
    if (response.statusCode != 200) throw Exception('Failed to set mode');
    return true;
  }

  Future<bool> playMelody(int melodyIndex) async {
    final response = await http.get(
      Uri.parse('$baseUrl/play?melody=$melodyIndex'),
    );
    if (response.statusCode != 200) throw Exception('Failed to play melody');
    return true;
  }

  Future<bool> setAlarm(int hour, int minute, int melodyIndex) async {
    final response = await http.post(
      Uri.parse('$baseUrl/setAlarm'),
      body: {
        'hour': hour.toString(),
        'minute': minute.toString(),
        'melody': melodyIndex.toString(),
      },
    );
    if (response.statusCode != 200) throw Exception('Failed to set alarm');
    return true;
  }

  Future<String> getLedState(String led) async {
    final response = await http.get(Uri.parse('$baseUrl/led/$led/status'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['${led}LED'];
    }
    throw Exception('Failed to get LED state');
  }
}