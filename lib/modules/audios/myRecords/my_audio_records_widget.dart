import 'package:flutter/material.dart';
import 'package:identa/core/extensions/context_extension.dart';
import 'package:identa/core/models/audio_recorder/audio_record.dart';
import 'package:identa/modules/audios/audioPlayer/audio_player_logic.dart';
import 'package:identa/modules/audios/audioPlayer/audio_player_card.dart';
import 'package:identa/widgets/dismissible_background.dart';
import 'package:provider/provider.dart'
    show Provider;

class MyAudioRecordsWidget extends StatefulWidget {
  const MyAudioRecordsWidget({
    super.key,
    this.padding,
    required this.updatedAudioRecords,
  });
  final List<AudioRecord> updatedAudioRecords;
  final EdgeInsets? padding;

  @override
  State<MyAudioRecordsWidget> createState() => _MyAudioRecordsWidgetState();
}

class _MyAudioRecordsWidgetState extends State<MyAudioRecordsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: widget.padding,
      itemCount: widget.updatedAudioRecords.length,
      itemBuilder: (context, index) {
        final audioRecord = widget.updatedAudioRecords[index];
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
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
