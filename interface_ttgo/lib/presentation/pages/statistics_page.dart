import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/datasources/firebase_datasource.dart';
import '../../data/entities/sensor_data.dart';
import '../bloc/statistics_bloc.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsBloc(FirebaseDataSource()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Statistiques'),
          actions: [
            PopupMenuButton<TimeRange>(
              onSelected: (TimeRange result) {
                context.read<StatisticsBloc>().add(LoadStatistics(result));
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<TimeRange>>[
                PopupMenuItem<TimeRange>(
                  value: TimeRange.hour,
                  child: Text('Dernière heure'),
                ),
                PopupMenuItem<TimeRange>(
                  value: TimeRange.day,
                  child: Text('Dernier jour'),
                ),
                PopupMenuItem<TimeRange>(
                  value: TimeRange.week,
                  child: Text('Dernière semaine'),
                ),
                PopupMenuItem<TimeRange>(
                  value: TimeRange.month,
                  child: Text('Dernier mois'),
                ),
              ],
            ),
          ],
        ),
        body: BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StatisticsLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTemperatureChart(state.data),
                    SizedBox(height: 24),
                    _buildLightChart(state.data),
                  ],
                ),
              );
            } else if (state is StatisticsError) {
              return Center(
                child: Text('Erreur: ${state.message}'),
              );
            }
            return Center(
              child: Text('Sélectionnez une période'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTemperatureChart(List<SensorData> data) {
    return SizedBox(
      height: 300,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Température',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 && value.toInt() < data.length) {
                              return Text(
                                DateFormat('HH:mm').format(data[value.toInt()].timestamp),
                                style: TextStyle(fontSize: 10),
                              );
                            }
                            return Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: data.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.temperature);
                        }).toList(),
                        isCurved: true,
                        color: Colors.red,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLightChart(List<SensorData> data) {
    return SizedBox(
      height: 300,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Luminosité',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 && value.toInt() < data.length) {
                              return Text(
                                DateFormat('HH:mm').format(data[value.toInt()].timestamp),
                                style: TextStyle(fontSize: 10),
                              );
                            }
                            return Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: data.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.light);
                        }).toList(),
                        isCurved: true,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}