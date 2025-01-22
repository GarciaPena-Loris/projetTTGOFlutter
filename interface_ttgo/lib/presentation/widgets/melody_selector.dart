import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/entities/melody_constants.dart';
import '../bloc/music_bloc.dart';

class MelodySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicBloc, MusicState>(
      listener: (context, state) {
        if (state is MusicPlaying) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Column(
        children: [
          for (int i = 0; i < MelodyConstants.melodies.length; i++)
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text(MelodyConstants.melodies[i]),
              trailing: IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  context
                      .read<MusicBloc>()
                      .add(PlayMelody(i + 1, MelodyConstants.melodies[i]));
                },
              ),
            ),
        ],
      ),
    );
  }
}
