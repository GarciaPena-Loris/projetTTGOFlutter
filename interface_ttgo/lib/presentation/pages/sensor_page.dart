import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interface_ttgo/presentation/bloc/sensor_bloc.dart';

import '../widgets/sensor_data_view.dart';
import '../widgets/visualization_selector.dart';

class SensorPage extends StatefulWidget {
  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  @override
  void initState() {
    super.initState();
    // Déclencher l'événement FetchSensorData lors de l'initialisation de la page
    context.read<SensorBloc>().add(FetchSensorData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Données des capteurs')),
      body: Column(
        children: [
          // Composant pour sélectionner le mode de visualisation
          VisualizationSelector(),
          // Affichage des données selon le mode sélectionné
          Expanded(
            child: BlocBuilder<SensorBloc, SensorState>(
              builder: (context, state) {
                if (state is SensorDataLoaded) {
                  return SensorDataView(
                    data: state.data,
                    visualizationType: state.visualizationType,
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}