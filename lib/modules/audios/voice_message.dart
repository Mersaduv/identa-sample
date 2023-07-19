import 'package:flutter/material.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/modules/audios/myRecords/my_audio_records_widget.dart';
import 'package:provider/provider.dart';

class VoiceMessage extends StatefulWidget {
  const VoiceMessage({
    super.key,
  });
  @override
  State<VoiceMessage> createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  @override
  Widget build(BuildContext context) {
    final audioRecordsProvider = Provider.of<NoteProvider>(context);
    final updatedAudioRecords = audioRecordsProvider.updatedAudioRecords;
    return Scaffold(
      body: SafeArea(
        child: MyAudioRecordsWidget(
          updatedAudioRecords: updatedAudioRecords,
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 88.0,
          ),
        ),
      ),
    );
  }
}
