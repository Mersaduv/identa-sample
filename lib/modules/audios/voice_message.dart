import 'package:flutter/material.dart';
import 'package:identa/classes/language_constants.dart';
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
    final deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: updatedAudioRecords.length,
      itemBuilder: (context, index) {
        final audioRecord = updatedAudioRecords[index];
        return Container(
          width: deviceWidth,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
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
                          print("pathaudio ${audioRecord.audioPath}");
                          String filePath = audioRecord.audioPath;
                          List<String> parts = filePath.split("/");
                          String fileName = parts.last;

                          List<String> fileNameParts = fileName.split(".");
                          String desiredPart = fileNameParts.first;
                          bool? shouldDelete = await ShowCustomDialog.show(
                            context,
                            translation(context).deleteVoice,
                            translation(context).areYouSureDeleteRecored,
                          );

                          if (shouldDelete == true) {
                            NoteModel? note = widget.note;

                            await noteProvider.deleteNoteAudio(
                                note, desiredPart, audioRecord);

                            print("pathFile ${audioRecord.audioPath}");

                            context.notify =
                                translation(context).audioRecordDismissed;
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
            ),
          ),
        );
      },
    ));
  }
}
