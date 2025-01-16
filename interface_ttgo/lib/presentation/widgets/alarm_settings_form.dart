import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/entities/melody_constants.dart';
import '../bloc/music_bloc.dart';

class AlarmSettingsForm extends StatefulWidget {
  @override
  _AlarmSettingsFormState createState() => _AlarmSettingsFormState();
}

class _AlarmSettingsFormState extends State<AlarmSettingsForm> {
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedMelody = MelodyConstants.melodies[0];

  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicBloc, MusicState>(
      listener: (context, state) {
        if (state is AlarmSet) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                title: Text('Heure du réveil'),
                trailing: TextButton(
                  child: Text(selectedTime.format(context)),
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setState(() => selectedTime = time);
                    }
                  },
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedMelody,
                decoration: InputDecoration(labelText: 'Mélodie'),
                items: MelodyConstants.melodies
                    .map((melody) => DropdownMenuItem(
                  value: melody,
                  child: Text(melody),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedMelody = value);
                  }
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Définir l\'alarme'),
                onPressed: () {
                  final melodyIndex = MelodyConstants.melodies.indexOf(selectedMelody) + 1;
                  context.read<MusicBloc>().add(SetAlarm(
                    hour: selectedTime.hour,
                    minute: selectedTime.minute,
                    melodyIndex: melodyIndex,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}