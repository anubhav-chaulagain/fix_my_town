import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

final shakeDetectorServiceProvider = Provider<ShakeDetectorService>((ref) {
  final service = ShakeDetectorService();
  ref.onDispose(() => service.dispose());
  return service;
});

class ShakeDetectorService {
  static const double _shakeThreshold = 20.0; // m/s² — sensitivity
  static const int _shakeCooldown = 2000; // ms — prevent multiple triggers

  final StreamController<void> _shakeController =
      StreamController<void>.broadcast();

  Stream<void> get onShake => _shakeController.stream;

  StreamSubscription? _subscription;
  int _lastShakeTime = 0;

  void startListening() {
    _subscription = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      final now = DateTime.now().millisecondsSinceEpoch;
      final timeSinceLastShake = now - _lastShakeTime;

      if (magnitude > _shakeThreshold && timeSinceLastShake > _shakeCooldown) {
        _lastShakeTime = now;
        _shakeController.add(null);
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    stopListening();
    _shakeController.close();
  }
}
