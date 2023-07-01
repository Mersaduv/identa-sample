import 'dart:async';

import 'package:flutter/material.dart';

class RecorderButton extends ChangeNotifier {
  Timer? _timer;
  bool _isRecord = false;
  bool _isButtonDisabled = false;
  int _recordDuration = 0;
  double _opacity = 1.0;

  bool get isButtonDisabled => _isButtonDisabled;
  bool get isRecord => _isRecord;
  double get opacity => _opacity;
  int get recordDuration => _recordDuration;
  Timer? get timer => _timer;

  Future<void> incrementRecordDuration() async {
    _recordDuration++;
    notifyListeners();
  }

  Future<void> resetRecordDuration() async {
    _recordDuration = 0;
    notifyListeners();
  }

  Future<void> setButtonDisabled(bool value) async {
    _isButtonDisabled = value;
    notifyListeners();
  }

  Future<void> setRecord(bool value) async {
    _isRecord = value;
    notifyListeners();
  }

  Future<void> toggleOpacity() async {
    _opacity = _opacity == 1.0 ? 0.0 : 1.0;
    notifyListeners();
  }

  Future<void> startTimer() async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      incrementRecordDuration();
      toggleOpacity();
    });
  }

  Future<void> stopTimer() async {
    _timer?.cancel();
    _timer = null;
    _recordDuration = 0;
  }
}
