import 'package:flutter/material.dart';
import 'package:interface_ttgo/data/datasources/mockesp32_api.dart';

class LEDControlCard extends StatefulWidget {
  final String led;

  const LEDControlCard({super.key, required this.led});

  @override
  _LEDControlCardState createState() => _LEDControlCardState();
}

class _LEDControlCardState extends State<LEDControlCard> {
  bool _isOn = false;
  final MockESP32Api _api = MockESP32Api(); // Mocked

  @override
  void initState() {
    super.initState();
    _fetchLedState();
  }

  Future<void> _fetchLedState() async {
    final state = await _api.getLedState(widget.led);
    setState(() {
      _isOn = state == 'on';
    });
  }

  Future<void> _toggleLed(bool value) async {
    final success = await _api.setLedState(widget.led, value);
    if (success) {
      setState(() {
        _isOn = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          widget.led == 'red' ? Icons.circle : Icons.circle,
          color: _isOn ? (widget.led == 'red' ? Colors.red : Colors.green) : Colors.grey,
        ),
        title: Text('LED ${widget.led}'),
        trailing: Switch(
          value: _isOn,
          onChanged: _toggleLed,
        ),
      ),
    );
  }
}