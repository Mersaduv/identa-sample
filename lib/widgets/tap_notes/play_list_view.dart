import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:identa/constants/colors.dart';

typedef _Fn = void Function();

class PlayListView extends StatefulWidget {
  List<String> audioFiles = [];
  String playerTime = '00:00:00';
  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  final _Fn? Function(dynamic audioFilesIndex) getPlaybackFn1;
  final _Fn? Function() getPauseResumeFn1;
  PlayListView(
      {Key? key,
      required this.audioFiles,
      required this.mPlayer,
      required this.playerTime,
      required this.getPlaybackFn1,
      required this.getPauseResumeFn1})
      : super(key: key);
  @override
  PlayListViewState createState() => PlayListViewState();
}

class PlayListViewState extends State<PlayListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.audioFiles.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          subtitle: FractionallySizedBox(
            widthFactor: 1,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 3, bottom: 3),
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      height: 70,
                      width: 280,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 214, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: MyColors.primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: IconButton(
                              onPressed: !widget.mPlayer!.isPaused
                                  ? widget
                                      .getPlaybackFn1(widget.audioFiles[index])
                                  : widget.getPauseResumeFn1(),
                              color: Colors.white,
                              icon: Icon(
                                widget.mPlayer!.isStopped
                                    ? Icons.play_arrow
                                    : (widget.mPlayer!.isPaused
                                        ? Icons.play_arrow
                                        : Icons.pause),
                                size: 33,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  widget.mPlayer!.isPlaying
                                      ? 'Playback in progress'
                                      : 'Player is stopped',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: MyColors.primaryColor)),
                              Text(
                                widget.playerTime,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.primaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          widget.audioFiles.removeAt(index);
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: MyColors.primaryColor,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                Text("type 1 ${widget.audioFiles[index]}")
              ],
            ),
          ),
        );
      },
    );
  }
}
