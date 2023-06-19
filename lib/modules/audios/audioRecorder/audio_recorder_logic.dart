import 'package:flutter/foundation.dart' show ValueNotifier, kDebugMode;
import 'package:identa/core/models/audio_recorder/audio_recorder_state.dart';
import 'package:identa/core/repositories/permission_repository.dart';
import 'package:record/record.dart' show Record, RecordPlatform;

typedef AudioRecorderStateNotifier = ValueNotifier<AudioRecorderState>;

abstract class AudioRecorderLogicInterface {
  AudioRecorderStateNotifier get stateNotifier;

  Future<void> start({String? path});
  Future<String?> stop();
  Future<void> onDispose();
}

class AudioRecorderLogic implements AudioRecorderLogicInterface {
  AudioRecorderLogic({
    required this.permissionRepository,
    RecordPlatform? recorder,
  }) : _recorder = recorder ?? Record();

  final PermissionRepositoryInterface permissionRepository;
  final RecordPlatform _recorder;
  final _stateNotifier =
      AudioRecorderStateNotifier(const AudioRecorderState.idle());

  set _notify(AudioRecorderState state) => _stateNotifier.value = state;

  @override
  AudioRecorderStateNotifier get stateNotifier => _stateNotifier;

  @override
  Future<void> start({String? path}) async {
    if (!await permissionRepository.hasMicrophonePermission) {
      throw Exception('No permission to record audio.');
    }

    _recorder.start(path: path);
    _notify = const AudioRecorderState.start();
  }
  /// Stops the voice recording and returns the audio path.
  @override
  Future<String?> stop() async {
    final audioPath = await _recorder.stop();
    if (kDebugMode) print('Audio Path: $audioPath');
    _notify = AudioRecorderState.stop(audioPath: audioPath);
    return audioPath;
  }

  @override
  Future<void> onDispose() => _recorder.dispose();
}
