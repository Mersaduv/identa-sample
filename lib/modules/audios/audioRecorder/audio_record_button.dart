import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/extensions/context_extension.dart';
import 'package:identa/core/models/audio_recorder/audio_record.dart';
import 'package:identa/core/repositories/file_picker_privider.dart';
import 'package:identa/core/repositories/permission_repository.dart';
import 'package:identa/modules/audios/audioRecorder/recorder_button.dart';
import 'package:identa/modules/audios/audioRecorder/audio_recorder_logic.dart';
import 'package:identa/modules/audios/myRecords/my_audio_records_logic.dart';
import 'package:identa/services/apis/api.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, ReadContext, WatchContext;

/// To use this widget, we need to instance [AudioRecorderLogicInterface] and
/// [MyAudioRecordsLogicInterface].
///
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

  Future<void> _stop(BuildContext context) async {
    final audioRecordLogic = context.read<AudioRecorderLogicInterface>();
    final myAudioRecordsLogic = context.read<MyAudioRecordsLogicInterface>();
    final audioRecordbutton = context.read<RecorderButton>();

    audioRecordbutton.stopTimer();
    final audioPath = await audioRecordLogic.stop();
    audioRecordbutton.setRecord(false);
    audioRecordbutton.setButtonDisabled(true);
    print(audioPath);
    if (audioPath != null) {
      final now = DateTime.now();
      final audioRecord = AudioRecord(
        formattedDate: DateFormat('yyyy-MM-dd – kk:mm:ss').format(now),
        audioPath: audioPath,
      );
      // print("voice format ${audioPath}");
      await myAudioRecordsLogic.add(audioRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioDelete = context.read<MyAudioRecordsLogicInterface>();
    final audioPath = context.watch<MyAudioRecordsLogicInterface>();
    final notifier = context.watch<AudioRecorderLogicInterface>().stateNotifier;
    final audioRecordLogics = context.read<RecorderButton>();
    final audioRecordshow = context.watch<RecorderButton>();
    final attachmentHandler = context.read<FilePickerProvider>();
    return ChangeNotifierProvider<AudioRecorderStateNotifier>.value(
      value: notifier,
      child: Consumer<AudioRecorderStateNotifier>(
        builder: (context, notifier, _) {
          final audioRecorderState = notifier.value;

          return Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: audioRecordshow.isRecord ? 385 : 56,
                    decoration: BoxDecoration(
                      color: audioRecordshow.isButtonDisabled
                          ? Colors.grey
                          : MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: audioRecordshow.isRecord
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AnimatedOpacity(
                                        opacity: audioRecordshow.opacity,
                                        duration:
                                            const Duration(milliseconds: 500),
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
                                            color: Colors.white, fontSize: 13),
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
                                        elevation: 0,
                                        backgroundColor: MyColors.primaryColor,
                                        onPressed: () async {
                                          if (!audioRecordshow
                                              .isButtonDisabled) {
                                            try {
                                              await audioRecorderState
                                                  .maybeWhen<Future<void>>(
                                                start: () => _stop(context),
                                                orElse: () => _start(context),
                                              );
                                              //!
                                              audioRecordLogics
                                                  .setButtonDisabled(true);
                                              audioDelete
                                                  .delete(audioPath.path);
                                            } catch (e) {
                                              final message = e.toString();
                                              context.notify = message;
                                            } finally {
                                              await Future.delayed(
                                                  const Duration(seconds: 2));
                                              audioRecordLogics
                                                  .setButtonDisabled(false);
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
                                        elevation: 0,
                                        backgroundColor: MyColors.primaryColor,
                                        onPressed: () async {
                                          if (!audioRecordshow
                                              .isButtonDisabled) {
                                            try {
                                              audioRecordLogics
                                                  .setButtonDisabled(true);

                                              await audioRecorderState
                                                  .maybeWhen<Future<void>>(
                                                start: () => _stop(context),
                                                orElse: () => _start(context),
                                              );
                                            } catch (e) {
                                              final message = e.toString();
                                              context.notify = message;
                                            } finally {
                                              await Future.delayed(
                                                  const Duration(seconds: 2));
                                              audioRecordLogics
                                                  .setButtonDisabled(false);
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
                            elevation: 0,
                            backgroundColor: audioRecordshow.isButtonDisabled
                                ? Colors.grey
                                : MyColors.primaryColor,
                            onPressed: () async {
                              if (!audioRecordshow.isButtonDisabled) {
                                try {
                                  await audioRecorderState
                                      .maybeWhen<Future<void>>(
                                    start: () => _stop(context),
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
              Visibility(
                visible: !audioRecordshow.isRecord,
                child: Positioned(
                  top: 0,
                  right: 8,
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: MyColors.primaryColor,
                    onPressed: () => attachmentHandler.pickFiles(),
                    child: const Icon(Icons.description),
                    // label: const Text('Pick file'),
                    // icon: const Icon(Icons.description)
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
