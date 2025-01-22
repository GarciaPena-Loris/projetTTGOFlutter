import 'package:flutter/material.dart';
import 'package:interface_ttgo/data/datasources/esp32_api.dart';
import 'package:interface_ttgo/data/datasources/mockesp32_api.dart';

class ModeControlCard extends StatefulWidget {
  final String mode;
  final String title;
  final bool hasThreshold;

  const ModeControlCard({required this.mode, required this.title, required this.hasThreshold});


  @override
  _ModeControlCardState createState() => _ModeControlCardState();
}

class _ModeControlCardState extends State<ModeControlCard> {
  bool _isOn = false;
  double _threshold = 0.1;
  final ESP32Api _api = ESP32Api();

  Future<void> _toggleMode(bool value) async {
    try {
      final success = await _api.setMode(widget.mode, value, _threshold);
      if (success) {
        setState(() {
          _isOn = value;
        });
      }
    } catch (e) {
      print('Error toggling mode: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set mode: $e')),
      );
    }
  }

  void _updateThreshold(double value) {
    setState(() {
      _threshold = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double minThreshold = widget.mode == 'nightMode' ? 0.0 : -10.0;
    double maxThreshold = widget.mode == 'nightMode' ? 3.0 : 50.0;
    int divisions = widget.mode == 'nightMode' ? 30 : 120;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              widget.mode == 'nightMode' ? Icons.nightlight_round : Icons.thermostat,
              color: _isOn ? (widget.mode == 'nightMode' ? Colors.yellow : Colors.orange) : Colors.grey,
            ),
            title: Text(widget.title),
            trailing: Switch(
              value: _isOn,
              onChanged: _toggleMode,
            ),
          ),
          if (widget.hasThreshold)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text('Seuil: ${_threshold.toStringAsFixed(1)}'),
                  Expanded(
                    child: Slider(
                      value: _threshold,
                      min: minThreshold,
                      max: maxThreshold,
                      divisions: divisions,
                      label: _threshold.toStringAsFixed(1),
                      onChanged: !_isOn ? _updateThreshold : null,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}