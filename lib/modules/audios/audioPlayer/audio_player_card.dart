import 'package:audio_waveforms/audio_waveforms.dart'
    show AudioFileWaveforms, PlayerWaveStyle, WaveformType;
import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/models/audio_recorder/audio_record.dart';
import 'package:identa/modules/audios/audioPlayer/audio_player_logic.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, WatchContext;

/// To use this widget, we need to instance [AudioPlayerLogicInterface].
class AudioPlayerCard extends StatelessWidget {
  const AudioPlayerCard(this.audioRecord, {super.key});

  final AudioRecord audioRecord;

  @override
  Widget build(BuildContext context) {
    final audioPlayerLogic = context.watch<AudioPlayerLogicInterface>();

    return ChangeNotifierProvider<AudioPlayerNotifier>.value(
      value: audioPlayerLogic.stateNotifier,
      child: Consumer<AudioPlayerNotifier>(
        builder: (_, notifier, __) {
          final audioPlayerState = notifier.value;

          return InkWell(
            onTap: () async {
              await audioPlayerState.when<Future<void>>(
                play: audioPlayerLogic.pause,
                pause: audioPlayerLogic.play,
              );
            },
            child: Container(
              width: 290,
              padding: const EdgeInsets.only(right: 15, left: 15),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 237, 252),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2993CF),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      audioPlayerState.when<IconData>(
                        play: () => Icons.pause,
                        pause: () => Icons.play_arrow,
                      ),
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AudioFileWaveforms(
                            playerController: audioPlayerLogic.playerController,
                            size:
                                Size(MediaQuery.of(context).size.width / 2, 45),
                            waveformType: WaveformType.fitWidth,
                            animationDuration: kThemeAnimationDuration,
                            enableSeekGesture: false,
                            playerWaveStyle: audioPlayerLogic.playerWaveStyle),
                        ColoredBox(
                          color: Colors.transparent,
                          child: StreamBuilder<int>(
                            stream: audioPlayerLogic
                                .playerController.onCurrentDurationChanged,
                            initialData: 0,
                            builder: (context, snapshot) {
                              final currentDuration = snapshot.data ?? 0;
                              final seconds = (currentDuration / 1000).round();
                              final minutes = (seconds / 60).floor();
                              final remainingSeconds = seconds % 60;
                              final formattedDuration =
                                  '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
                              return Text(
                                formattedDuration,
                                style: const TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
