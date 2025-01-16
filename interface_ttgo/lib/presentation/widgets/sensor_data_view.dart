import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../data/entities/sensor_data.dart';
import '../bloc/sensor_bloc.dart';

class SensorDataView extends StatelessWidget {
  final SensorData data;
  final VisualizationType visualizationType;

  const SensorDataView({
    Key? key,
    required this.data,
    required this.visualizationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (visualizationType) {
      case VisualizationType.text:
        return _buildTextView();
      case VisualizationType.gauge:
        return _buildGaugeView();
      case VisualizationType.json:
        return _buildJSONView();
    }
  }

  Widget _buildTextView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCard(
            emoji: '🌡️',
            label: 'Température',
            value: '${data.temperature.toStringAsFixed(2)}°C',
            color: _getTemperatureColor(data.temperature),
          ),
          _buildCard(
            emoji: '💡',
            label: 'Luminosité',
            value: '${data.light.toStringAsFixed(2)}V',
            color: _getLightColor(data.light),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      {required String emoji,
      required String label,
      required String value,
      required Color color}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.all(16),
      child: Container(
        width: 300, // Augmenter la largeur des rectangles
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              '$emoji $label:',
              style:
                  TextStyle(fontSize: 20, color: Colors.black), // Texte en noir
            ),
            SizedBox(width: 8), // Espacement entre le label et la valeur
            Text(
              value,
              style:
                  TextStyle(fontSize: 20, color: color), // Couleur de la valeur
            ),
          ],
        ),
      ),
    );
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 0) return Colors.blue;
    if (temperature < 25) return Colors.green;
    return Colors.red;
  }

  Color _getLightColor(double light) {
    if (light < 1) return Colors.grey;
    if (light < 2.5) return Colors.orange;
    return Colors.yellow;
  }

  Widget _buildGaugeView() {
    return Row(
      children: [
        Expanded(
          child: SfRadialGauge(
            title: GaugeTitle(text: 'Température'),
            axes: <RadialAxis>[
              RadialAxis(
                minimum: -10,
                maximum: 50,
                ranges: <GaugeRange>[
                  GaugeRange(startValue: -10, endValue: 0, color: Colors.blue),
                  GaugeRange(startValue: 0, endValue: 25, color: Colors.green),
                  GaugeRange(startValue: 25, endValue: 50, color: Colors.red),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(value: data.temperature)
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SfRadialGauge(
            title: GaugeTitle(text: 'Luminosité'),
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 3.3,
                ranges: <GaugeRange>[
                  GaugeRange(startValue: 0, endValue: 1, color: Colors.grey),
                  GaugeRange(
                      startValue: 1, endValue: 2.5, color: Colors.orange),
                  GaugeRange(
                      startValue: 2.5, endValue: 3.3, color: Colors.yellow),
                ],
                pointers: <GaugePointer>[NeedlePointer(value: data.light)],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJSONView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Text(
              _formatJson(data),
              style: TextStyle(fontSize: 16, fontFamily: 'Courier'),
            ),
          ),
        ),
      ),
    );
  }

  String _formatJson(SensorData data) {
    final jsonData = {
      'temperature': data.temperature,
      'light': data.light,
      'timestamp': data.timestamp.toIso8601String(),
    };
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(jsonData);
  }
}
