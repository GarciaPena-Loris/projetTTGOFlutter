import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/led_control_card.dart';
import '../widgets/mode_control_card.dart';

class ControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contrôle des LEDs')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            LEDControlCard(led: 'red'),
            LEDControlCard(led: 'green'),
            ModeControlCard(
              mode: 'nightMode',
              title: 'Mode Nuit',
              hasThreshold: true,
            ),
            ModeControlCard(
              mode: 'thermometerMode',
              title: 'Mode Thermomètre',
              hasThreshold: true,
            ),
          ],
        ),
      ),
    );
  }
}