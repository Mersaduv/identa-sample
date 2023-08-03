import 'dart:async';
import 'dart:convert';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/extensions/context_extension.dart';
import 'package:identa/core/models/audio_recorder/audio_files.dart';
import 'package:identa/core/models/audio_recorder/audio_record.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/core/repositories/permission_repository.dart';
import 'package:identa/modules/audios/audioRecorder/recorder_button.dart';
import 'package:identa/modules/audios/audioRecorder/audio_recorder_logic.dart';
import 'package:identa/services/apis/api.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, Provider, ReadContext, WatchContext;

class AudioRecorderButton extends StatelessWidget {
  const AudioRecorderButton({super.key});

  Future<void> _start(BuildContext context) async {
    final _hasPermissionRecorder =
        context.read<PermissionRepositoryInterface>();
    final audioRecordLogic = context.read<AudioRecorderLogicInterface>();
    final audioRecordbutton = context.read<RecorderButton>();
    audioRecordbutton.setRecord(true);
    if (await _hasPermissionRecorder.hasMicrophonePermission) {
      audioRecordbutton.startTimer();
    }

    await audioRecordLogic.start();
  }

  Future<void> _stop(BuildContext context, bool isCancel) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    final audioRecordsProvider =
        Provider.of<NoteProvider>(context, listen: false);
    final setTextBody = Provider.of<NoteProvider>(context, listen: false);
    final noteProvider = context.read<NoteProvider>();
    final audioRecordLogic = context.read<AudioRecorderLogicInterface>();
    final audioRecordbutton = context.read<RecorderButton>();
    if (!isCancel) {
      audioRecordbutton.stopTimer();
      final audioPath = await audioRecordLogic.stop();
      audioRecordbutton.setRecord(false);
      print(audioPath);
      if (audioPath != null) {
        final now = DateTime.now();
        final audioRecord = AudioRecord(
          formattedDate: DateFormat('yyyy-MM-dd – kk:mm:ss').format(now),
          audioPath: audioPath,
        );
        //  await myAudioRecordsLogic.add(audioRecord);
        final response = await ServiceApis.sendAudioFile(audioRecord.audioPath);
        String fileId = jsonDecode(response.body)['fileId'];
        String textBody = jsonDecode(response.body)["text"];
        print('Response voice: ${fileId} FIRST');

        setTextBody.addAudioText(textBody);
        final responseDownlaod = await ServiceApis.downloadAudio(fileId);
        final audioPlayer = FlutterSoundPlayer();
        await audioPlayer.openPlayer();
        await audioPlayer
            .setSubscriptionDuration(const Duration(milliseconds: 10));
        await audioPlayer.startPlayer(fromURI: responseDownlaod.toString());
        await Future.delayed(const Duration(milliseconds: 10));
        final audioDuration = await audioPlayer.getProgress();
        await audioPlayer.closePlayer();
        noteProvider.setAudioFile(AudioFile(
            fileId: fileId, length: audioDuration['duration']!.inSeconds));
        final audioRecordResponse = AudioRecord(
          formattedDate: DateFormat('yyyy-MM-dd – kk:mm:ss').format(now),
          audioPath: responseDownlaod.toString(),
          length: audioDuration['duration']!.inSeconds,
        );
        audioRecordsProvider.addAudioRecord(audioRecordResponse);
        await audioRecordbutton.setButtonDisabled(true);
      }
    } else {
      await audioRecordLogic.stop();
      audioRecordbutton.stopTimer();
      audioRecordLogic.cancelRecord();
      audioRecordLogic.onDispose();
      audioRecordbutton.setRecord(false);
      await audioRecordbutton.setButtonDisabled(true);
      print("calceled !");
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<AudioRecorderLogicInterface>().stateNotifier;
    final audioRecordLogics = context.read<RecorderButton>();
    final audioRecordshow = context.watch<RecorderButton>();
    return ChangeNotifierProvider<AudioRecorderStateNotifier>.value(
      value: notifier,
      child: Consumer<AudioRecorderStateNotifier>(
        builder: (context, notifier, _) {
          final audioRecorderState = notifier.value;
          return LayoutBuilder(
            builder: (context, constraints) {
              final screenSize = MediaQuery.of(context).size;
              final containerWidth = screenSize.width * 0.93;
              return Stack(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          margin: const EdgeInsets.only(left: 7),
                          duration: const Duration(milliseconds: 300),
                          width:
                              audioRecordshow.isRecord ? containerWidth : 56.0,
                          decoration: BoxDecoration(
                            color: audioRecordshow.isButtonDisabled
                                ? Colors.grey
                                : MyColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: audioRecordshow.isRecord
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: AnimatedOpacity(
                                              opacity: audioRecordshow.opacity,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${(audioRecordshow.recordDuration ~/ 60).toString().padLeft(2, '0')}:${(audioRecordshow.recordDuration % 60).toString().padLeft(2, '0')}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: FloatingActionButton(
                                              heroTag: "btn2",
                                              elevation: 0,
                                              backgroundColor:
                                                  MyColors.primaryColor,
                                              onPressed: () async {
                                                if (!audioRecordshow
                                                    .isButtonDisabled) {
                                                  try {
                                                    audioRecordLogics
                                                        .setButtonDisabled(
                                                            true);
                                                    await audioRecorderState
                                                        .maybeWhen<
                                                            Future<void>>(
                                                      start: () =>
                                                          _stop(context, true),
                                                      orElse: () =>
                                                          _start(context),
                                                    );
                                                  } catch (e) {
                                                    final message =
                                                        e.toString();
                                                    context.notify = message;
                                                  } finally {
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    audioRecordLogics
                                                        .setButtonDisabled(
                                                            false);
                                                  }
                                                }
                                              },
                                              child: Icon(
                                                audioRecorderState
                                                    .maybeWhen<IconData>(
                                                  start: () => Icons.delete,
                                                  orElse: () => Icons.mic,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // const SizedBox(width: 10),
                                          Expanded(
                                            child: FloatingActionButton(
                                              heroTag: "btn3",
                                              elevation: 0,
                                              backgroundColor:
                                                  MyColors.primaryColor,
                                              onPressed: () async {
                                                if (!audioRecordshow
                                                    .isButtonDisabled) {
                                                  try {
                                                    audioRecordLogics
                                                        .setButtonDisabled(
                                                            true);

                                                    await audioRecorderState
                                                        .maybeWhen<
                                                            Future<void>>(
                                                      start: () =>
                                                          _stop(context, false),
                                                      orElse: () =>
                                                          _start(context),
                                                    );
                                                  } catch (e) {
                                                    final message =
                                                        e.toString();
                                                    context.notify = message;
                                                  } finally {
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    audioRecordLogics
                                                        .setButtonDisabled(
                                                            false);
                                                  }
                                                }
                                              },
                                              child: Icon(
                                                audioRecorderState
                                                    .maybeWhen<IconData>(
                                                  start: () => Icons.send,
                                                  orElse: () => Icons.mic,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : FloatingActionButton(
                                  heroTag: "btn1",
                                  elevation: 0,
                                  backgroundColor:
                                      audioRecordshow.isButtonDisabled
                                          ? Colors.grey
                                          : MyColors.primaryColor,
                                  onPressed: () async {
                                    if (!audioRecordshow.isButtonDisabled) {
                                      try {
                                        await audioRecorderState
                                            .maybeWhen<Future<void>>(
                                          start: () => _stop(context, false),
                                          orElse: () => _start(context),
                                        );
                                      } catch (e) {
                                        final message = e.toString();
                                        context.notify = message;
                                      }
                                    }
                                  },
                                  child: Icon(
                                    audioRecorderState.maybeWhen<IconData>(
                                      start: () => Icons.stop,
                                      orElse: () => Icons.mic,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
