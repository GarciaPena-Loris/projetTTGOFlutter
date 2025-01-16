import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/sensor_bloc.dart';

class VisualizationSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SegmentedButton<VisualizationType>(
        segments: [
          ButtonSegment<VisualizationType>(
            value: VisualizationType.text,
            label: Text('Texte'),
            icon: Icon(Icons.text_fields),
          ),
          ButtonSegment<VisualizationType>(
            value: VisualizationType.gauge,
            label: Text('Jauge'),
            icon: Icon(Icons.speed),
          ),
          ButtonSegment<VisualizationType>(
            value: VisualizationType.json,
            label: Text('JSON'),
            icon: Icon(Icons.code), // Icône pour JSON
          ),
        ],
        selected: {context.watch<SensorBloc>().state is SensorDataLoaded
            ? (context.watch<SensorBloc>().state as SensorDataLoaded).visualizationType
            : VisualizationType.text},
        onSelectionChanged: (Set<VisualizationType> selected) {
          context.read<SensorBloc>().add(ChangeVisualization(selected.first));
        },
      ),
    );
  }
}