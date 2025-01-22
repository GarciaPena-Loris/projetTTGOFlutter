import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/datasources/firebase_datasource.dart';
import '../../data/entities/sensor_data.dart';
import '../../data/datasources/mockesp32_api.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _selectedGrouping = 'minute';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
        actions: [
          DropdownButton<String>(
            value: _selectedGrouping,
            items: [
              DropdownMenuItem(value: 'minute', child: Text('Par minute')),
              DropdownMenuItem(value: 'hour', child: Text('Par heure')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGrouping = value!;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SensorData>>(
        future: getDatas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            final data = _groupData(snapshot.data!);
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTemperatureChart(data),
                  SizedBox(height: 24),
                  _buildLightChart(data),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<SensorData>> getDatas() async {
  print('Fetching data from Firebase');
  List<SensorData> data = [];
  DateTime now = DateTime.now();

  // Fetch data from Firebase for the last 30 days
  final fetchedData = await FirebaseDataSource().getSensorDataInRange(now.subtract(Duration(days: 30)), now);

  // Process the fetched data
  for (var entry in fetchedData) {
    data.add(SensorData(
      temperature: entry.temperature,
      light: entry.light,
      timestamp: entry.timestamp,
    ));
  }

  print('Fetched ${data.length} entries from Firebase');
  return data;
}

  List<SensorData> _groupData(List<SensorData> data) {
    if (_selectedGrouping == 'minute') {
      return data.take(50).toList();
    } else {
      Map<int, List<SensorData>> groupedData = {};
      for (var entry in data) {
        int hour = entry.timestamp.hour;
        if (!groupedData.containsKey(hour)) {
          groupedData[hour] = [];
        }
        groupedData[hour]!.add(entry);
      }
      return groupedData.entries.map((entry) {
        double avgTemp = entry.value.map((e) => e.temperature).reduce((a, b) => a + b) / entry.value.length;
        double avgLight = entry.value.map((e) => e.light).reduce((a, b) => a + b) / entry.value.length;
        return SensorData(
          temperature: avgTemp,
          light: avgLight,
          timestamp: DateTime(entry.value.first.timestamp.year, entry.value.first.timestamp.month, entry.value.first.timestamp.day, entry.key),
        );
      }).toList();
    }
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
                                DateFormat(_selectedGrouping == 'minute' ? 'HH:mm' : 'HH').format(data[value.toInt()].timestamp),
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
                                DateFormat(_selectedGrouping == 'minute' ? 'HH:mm' : 'HH').format(data[value.toInt()].timestamp),
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