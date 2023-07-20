import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/repositories/file_picker_privider.dart';
import 'package:identa/modules/audios/audioRecorder/audio_record_button.dart';
import 'package:identa/modules/audios/audioRecorder/recorder_button.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final audioRecordshow = context.watch<RecorderButton>();
    final attachmentHandler = context.read<FilePickerProvider>();

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      margin: const EdgeInsets.only(left: 4, right: 4),
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(11),
          bottomRight: Radius.circular(11),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AudioRecorderButton(),
          Visibility(
            visible: !audioRecordshow.isRecord,
            child: Container(
              color: MyColors.primaryColor,
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
      ),
    );
  }
}
