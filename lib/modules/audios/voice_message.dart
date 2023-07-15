import 'package:flutter/material.dart';
import 'package:identa/core/repositories/permission_repository.dart';
import 'package:identa/core/repositories/storage_repository.dart';
import 'package:identa/modules/audios/audioRecorder/audio_recorder_logic.dart';
import 'package:identa/modules/audios/audioRecorder/audio_record_button.dart';
import 'package:identa/modules/audios/myRecords/my_audio_records_logic.dart';
import 'package:identa/modules/audios/myRecords/my_audio_records_widget.dart';
import 'package:provider/provider.dart'
    show MultiProvider, Provider, ReadContext;
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

class VoiceMessage extends StatelessWidget {
  const VoiceMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: MyAudioRecordsWidget(
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 88.0,
          ),
        ),
      ),
    );
  }
}
