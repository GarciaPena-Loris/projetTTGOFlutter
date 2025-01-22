import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interface_ttgo/presentation/pages/sensor_page.dart';
import 'package:interface_ttgo/presentation/bloc/sensor_bloc.dart';
import 'package:interface_ttgo/data/datasources/mockesp32_api.dart';
import 'package:interface_ttgo/presentation/bloc/music_bloc.dart';
import 'package:interface_ttgo/data/datasources/firebase_datasource.dart';
import 'package:interface_ttgo/presentation/pages/statistics_page.dart';

import '../../data/datasources/esp32_api.dart';
import 'control_page.dart';
import 'music_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    SensorPage(),
    ControlPage(),
    BlocProvider(
      create: (context) => MusicBloc(),
      child: MusicPage(),
    ),
    StatisticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SensorBloc(ESP32Api(), FirebaseDataSource()),
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.sensors),
              label: 'Capteurs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb),
              label: 'Contrôle',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Musique',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Statistiques',
            ),
          ],
        ),
      ),
    );
  }
}