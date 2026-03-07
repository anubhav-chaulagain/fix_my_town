import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeScrollService {
  final ScrollController scrollController = ScrollController();
  StreamSubscription? _subscription;

  static const double _sensitivity = 8.0;
  static const double _deadzone = 1.0; // accelerometer units are different

  void startListening() {
    _subscription = accelerometerEventStream().listen((event) {
      // X axis on accelerometer = phone tilt forward/backward
      // When flat: ~0, tilt forward: positive, tilt back: negative
      final tilt = -event.x;

      if (tilt.abs() < _deadzone) return;

      if (!scrollController.hasClients) return;

      final current = scrollController.offset;
      final max = scrollController.position.maxScrollExtent;
      final newOffset = (current + tilt * _sensitivity).clamp(0.0, max);

      scrollController.jumpTo(newOffset);
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    stopListening();
    scrollController.dispose();
  }
}
