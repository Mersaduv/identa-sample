import 'package:flutter/material.dart';
import 'package:identa/core/extensions/context_extension.dart';
import 'package:identa/core/models/model_core/note_model.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/modules/audios/audioPlayer/audio_player_card.dart';
import 'package:identa/modules/audios/audioPlayer/audio_player_logic.dart';
import 'package:identa/widgets/show_custom_dialog.dart';
import 'package:provider/provider.dart';

class VoiceMessage extends StatefulWidget {
  const VoiceMessage({super.key, this.note});
  final NoteModel? note;
  @override
  State<VoiceMessage> createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final updatedAudioRecords = noteProvider.updatedAudioRecords;
    return SafeArea(
        child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: updatedAudioRecords.length,
      itemBuilder: (context, index) {
        final audioRecord = updatedAudioRecords[index];
        return Padding(
          padding: const EdgeInsets.all(10),
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
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    onPressed: () async {
                      String fileId = Uri.parse(audioRecord.audioPath)
                          .pathSegments
                          .last
                          .replaceAll('.m4a', '');

                      bool? shouldDelete = await ShowCustomDialog.show(
                        context,
                        'Delete Voice',
                        'Are you sure you want to delete this audio recording?',
                      );

                      if (shouldDelete == true) {
                        // noteProvider.deleteNoteAudio(widget.note!, fileId);
                        print(
                            "pathFile ${audioRecord.audioPath} | ${audioRecord.formattedDate}");
                        noteProvider.updatedAudioRecords
                            .removeWhere((f) => f == audioRecord);

                        context.notify = 'Audio record dismissed';
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 250, 121, 112),
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
