import 'package:flutter/material.dart';
import 'package:identa/core/extensions/context_extension.dart';
import 'package:identa/modules/audios/audioPlayer/audio_player_logic.dart';
import 'package:identa/modules/audios/audioPlayer/audio_player_card.dart';
import 'package:identa/modules/audios/myRecords/my_audio_records_logic.dart';
import 'package:identa/widgets/dismissible_background.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, Provider, ReadContext, WatchContext;

/// To use this widget, we need to instance [MyAudioRecordsLogicInterface].
class MyAudioRecordsWidget extends StatelessWidget {
  const MyAudioRecordsWidget({
    super.key,
    this.padding,
  });

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final notifier =
        context.watch<MyAudioRecordsLogicInterface>().stateNotifier;
    return ChangeNotifierProvider<AudioRecordsNotifier>.value(
      value: notifier,
      child: Consumer<AudioRecordsNotifier>(
        builder: (_, notifier, __) {
          final myAudioRecords = notifier.value;

          if (myAudioRecords.isEmpty) {
            return const Center(
              child: Text(''),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: padding,
            itemCount: myAudioRecords.length,
            itemBuilder: (context, index) {
              final audioRecord = myAudioRecords[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Dismissible(
                  key: Key(audioRecord.toString()),
                  background: const DismissibleBackground(),
                  onDismissed: (_) {
                    context
                        .read<MyAudioRecordsLogicInterface>()
                        .delete(audioRecord);
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
                              context
                                  .read<MyAudioRecordsLogicInterface>()
                                  .delete(audioRecord);
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
        },
      ),
    );
  }
}
