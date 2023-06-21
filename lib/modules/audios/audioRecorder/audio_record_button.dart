import 'dart:async';

import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/extensions/context_extension.dart';
import 'package:identa/core/models/audio_recorder/audio_record.dart';
import 'package:identa/core/repositories/permission_repository.dart';
import 'package:identa/modules/audios/audioRecorder/audio_recorder_logic.dart';
import 'package:identa/modules/audios/myRecords/my_audio_records_logic.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, ReadContext, WatchContext;
import 'package:record/record.dart';

/// To use this widget, we need to instance [AudioRecorderLogicInterface] and
/// [MyAudioRecordsLogicInterface].
///
class AudioRecorderButton extends StatefulWidget {
  const AudioRecorderButton({Key? key}) : super(key: key);

  @override
  _AudioRecorderButtonState createState() => _AudioRecorderButtonState();
}

class _AudioRecorderButtonState extends State<AudioRecorderButton> {
  bool isRecord = false;
  bool isButtonDisabled = false;

  Timer? _timer;
  int _recordDuration = 0;
  double _opacity = 1.0;
  Future<void> _start(BuildContext context) async {
    final _hasPermissionRecorder =
        context.read<PermissionRepositoryInterface>();
    final audioRecordLogic = context.read<AudioRecorderLogicInterface>();
    setState(() {
      isRecord = true;
    });
    if (await _hasPermissionRecorder.hasMicrophonePermission) {
      _startTimer();
    }

    await audioRecordLogic.start();
  }

  Future<void> _stop(BuildContext context) async {
    final audioRecordLogic = context.read<AudioRecorderLogicInterface>();
    final myAudioRecordsLogic = context.read<MyAudioRecordsLogicInterface>();
    _timer?.cancel();
    _recordDuration = 0;
    final audioPath = await audioRecordLogic.stop();
    setState(() {
      isRecord = false;
      isButtonDisabled = true;
    });

    if (audioPath != null) {
      final now = DateTime.now();
      final audioRecord = AudioRecord(
        formattedDate: DateFormat('yyyy-MM-dd – kk:mm:ss').format(now),
        audioPath: audioPath,
      );
      await myAudioRecordsLogic.add(audioRecord);
    }
  }

  Future<void> _startTimer() async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
      setState(() => _opacity = _opacity == 1.0 ? 0.0 : 1.0);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<AudioRecorderLogicInterface>().stateNotifier;

    return ChangeNotifierProvider<AudioRecorderStateNotifier>.value(
      value: notifier,
      child: Consumer<AudioRecorderStateNotifier>(
        builder: (context, notifier, _) {
          final audioRecorderState = notifier.value;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isRecord ? 385 : 56,
            decoration: BoxDecoration(
              color: isButtonDisabled ? Colors.grey : MyColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: isRecord
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AnimatedOpacity(
                                opacity: _opacity,
                                duration: const Duration(milliseconds: 500),
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
                                '${(_recordDuration ~/ 60).toString().padLeft(2, '0')}:${(_recordDuration % 60).toString().padLeft(2, '0')}',
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
                                },
                                child: Icon(
                                  audioRecorderState.maybeWhen<IconData>(
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
                                },
                                child: Icon(
                                  size: 28,
                                  audioRecorderState.maybeWhen<IconData>(
                                    start: () => Icons.stop,
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
                                  if (!isButtonDisabled) {
                                    try {
                                      setState(() {
                                        isButtonDisabled = true;
                                      });
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
                                      setState(() {
                                        isButtonDisabled = false;
                                      });
                                    }
                                  }
                                },
                                child: Icon(
                                  audioRecorderState.maybeWhen<IconData>(
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
                : Expanded(
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: isButtonDisabled
                          ? Colors.grey
                          : MyColors.primaryColor,
                      onPressed: () async {
                        if (!isButtonDisabled) {
                          try {
                            await audioRecorderState.maybeWhen<Future<void>>(
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
          );
        },
      ),
    );
  }
}
