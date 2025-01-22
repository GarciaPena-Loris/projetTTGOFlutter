import 'package:http/http.dart' as http;
import 'dart:convert';

class ESP32Api {
  final String baseUrl = 'http://192.168.1.14';

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

  Future<bool> setMode(String mode, bool value, double threshold) async {
    String endpoint;
    if (mode == 'nightMode') {
      endpoint = '$baseUrl/control/nightMode?state=$value&seuil=$threshold';
    } else if (mode == 'thermometerMode') {
      endpoint = '$baseUrl/control/thermometreMode?state=$value&seuil=$threshold';
    } else {
      throw Exception('Unknown mode: $mode');
    }

    try {
      final response = await http.post(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to set mode: ${response.body}');
        throw Exception('Failed to set mode: ${response.body}');
      }
    } catch (e) {
      print('Error setting mode: $e');
      throw Exception('Failed to set mode: $e');
    }
  }

  Future<bool> playMelody(int melodyIndex) async {
    final String endpoint = '$baseUrl/play?melody=$melodyIndex';

    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to play melody: ${response.body}');
        throw Exception('Failed to play melody: ${response.body}');
      }
    } catch (e) {
      print('Error playing melody: $e');
      throw Exception('Failed to play melody: $e');
    }
  }

  Future<bool> setAlarm(int hour, int minute, int melodyIndex) async {
    final String endpoint = '$baseUrl/setAlarm?hour=$hour&minute=$minute&melody=$melodyIndex';
    try {
      final response = await http.post(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to set alarm: ${response.body}');
        throw Exception('Failed to set alarm: ${response.body}');
      }
    } catch (e) {
      print('Error setting alarm: $e');
      throw Exception('Failed to set alarm: $e');
    }
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