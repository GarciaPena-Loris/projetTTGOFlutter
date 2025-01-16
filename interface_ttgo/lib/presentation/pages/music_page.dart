import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/alarm_settings_form.dart';
import '../widgets/melody_selector.dart';

class MusicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Musique & Alarme')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jouer une mélodie', style: Theme.of(context).textTheme.titleLarge),
            MelodySelector(),
            SizedBox(height: 32),
            Text('Définir une alarme', style: Theme.of(context).textTheme.titleLarge),
            AlarmSettingsForm(),
          ],
        ),
      ),
    );
  }
}