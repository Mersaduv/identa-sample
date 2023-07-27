import 'dart:async' show Completer, Future, StreamSubscription;

import 'package:audio_waveforms/audio_waveforms.dart'
    show
        FinishMode,
        PlayerController,
        PlayerState,
        PlayerStateExtension,
        PlayerWaveStyle;
import 'package:flutter/foundation.dart' show ValueNotifier, visibleForTesting;
import 'package:flutter/material.dart';
import 'package:identa/core/models/audio_recorder/audio_player_state.dart';

typedef AudioPlayerNotifier = ValueNotifier<AudioPlayerState>;

abstract class AudioPlayerLogicInterface {
  PlayerController get playerController;
  AudioPlayerNotifier get stateNotifier;
  Future<void> play();
  Future<void> pause();
  Future<void> onDispose();
}

class AudioPlayerLogic implements AudioPlayerLogicInterface {
  AudioPlayerLogic({
    required String audioPath,
    PlayerController? playerController,
  }) : _playerController = playerController ?? PlayerController() {
    _setupAsync(audioPath: audioPath);
  }

  final Completer<void> _completer = Completer<void>();
  @visibleForTesting
  Completer<void> get completer => _completer;
  final PlayerController _playerController;
  final _stateNotifier = AudioPlayerNotifier(const AudioPlayerState.pause());
  StreamSubscription<PlayerState>? _playerStateStream;
  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.black12,
    liveWaveColor: Colors.blue,
    spacing: 6,
  );
  Future<void> _setupAsync({required String audioPath}) async {
    _playerStateStream = _playerController.onPlayerStateChanged.listen((state) {
      notify = _isPlayingState
          ? const AudioPlayerState.play()
          : const AudioPlayerState.pause();
    });
    await _playerController.preparePlayer(
      path: audioPath,
      shouldExtractWaveform: true,
      noOfSamples: playerWaveStyle.getSamplesForWidth(200),
      volume: 1.0,
    );
    _completer.complete();
  }

  Future<void> _waitSetup() async {
    if (!_completer.isCompleted) await _completer.future;
  }

  bool get _isPlayingState => _playerController.playerState.isPlaying;

  @visibleForTesting
  set notify(AudioPlayerState state) => _stateNotifier.value = state;

  @override
  PlayerController get playerController => _playerController;

  @override
  AudioPlayerNotifier get stateNotifier => _stateNotifier;

  @override
  Future<void> play() async {
    await _waitSetup();
    await _playerController.startPlayer(finishMode: FinishMode.pause);
  }

  @override
  Future<void> pause() async {
    await _waitSetup();
    await _playerController.pausePlayer();
  }

  @override
  Future<void> onDispose() async {
    _playerStateStream?.cancel();
    _playerController.dispose();
  }
}
