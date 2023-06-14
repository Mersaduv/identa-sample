import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:identa/constants/colors.dart';

typedef _Fn = void Function();

class NoteMicrophone extends StatelessWidget {
  final _Fn? Function() getRecorderFn;
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  String recordingTime = '00:00:00';
  bool isCircleVisible = true;
  NoteMicrophone(
      {Key? key,
      required this.mRecorder,
      required this.getRecorderFn,
      required this.recordingTime,
      required this.isCircleVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: mRecorder!.isRecording ? 360.0 : 56.0,
      child: FloatingActionButton(
        backgroundColor: MyColors.primaryColor,
        onPressed: getRecorderFn(),
        child: mRecorder!.isRecording
            ? Padding(
                padding: const EdgeInsets.only(right: 10, left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          width: isCircleVisible ? 10 : 0,
                          height: isCircleVisible ? 10 : 0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          recordingTime,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(width: 38),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () async {},
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 23,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.stop,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            onPressed: getRecorderFn(),
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 23,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : const Icon(
                Icons.mic,
                color: Colors.white,
              ),
      ),
    );
  }
}
