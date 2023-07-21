import 'package:flutter/material.dart';
import 'package:identa/core/extensions/context_extension.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/modules/audios/audioPlayer/audio_player_card.dart';
import 'package:identa/modules/audios/audioPlayer/audio_player_logic.dart';
import 'package:identa/widgets/dismissible_background.dart';
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: updatedAudioRecords.length,
      itemBuilder: (context, index) {
        final audioRecord = updatedAudioRecords[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Dismissible(
            key: Key(audioRecord.toString()),
            background: const DismissibleBackground(),
            onDismissed: (_) {
              //context.read<MyAudioRecordsLogicInterface>().delete(audioRecord);
              context.notify = 'Audio record dismissed';
            },
            child: Provider<AudioPlayerLogicInterface>(
              create: (_) => AudioPlayerLogic(
                audioPath: audioRecord.audioPath,
              ),
              dispose: (_, logic) => logic.onDispose(),
              child: Row(
                children: [
                  AudioPlayerCard(
                    audioRecord,
                    key: Key(audioRecord.audioPath),
                  ),
                  IconButton(
                    onPressed: () {
                      // context
                      //     .read<MyAudioRecordsLogicInterface>()
                      //     .delete(audioRecord);
                      context.notify = 'Audio record dismissed';
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 250, 121, 112),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
