import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shake_plus/shake_plus.dart';

final shakeServiceProvider = Provider<ShakeService>((ref) {
  final service = ShakeService();
  ref.onDispose(service.stopListening);
  return service;
});

class ShakeService {
  ShakeDetector? _detector;

  void startListening({
    required VoidCallback onShake,
    int minimumShakeCount = 1,
    int shakeSlopTimeMS = 600,
    int shakeCountResetTime = 2500,
    double shakeThresholdGravity = 2.2,
  }) {
    stopListening();
    _detector = ShakeDetector.autoStart(
      onPhoneShake: onShake,
      shakeThresholdGravity: shakeThresholdGravity,
      minimumShakeCount: minimumShakeCount,
      shakeSlopTimeMS: shakeSlopTimeMS,
      shakeCountResetTime: shakeCountResetTime,
    );
  }

  void stopListening() {
    _detector?.stopListening();
    _detector = null;
  }
}
