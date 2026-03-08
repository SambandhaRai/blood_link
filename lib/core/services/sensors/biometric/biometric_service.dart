import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService(LocalAuthentication());
});

class BiometricService {
  final LocalAuthentication _auth;
  bool _isAuthenticating = false;
  DateTime? _uiUnavailableRetryAfter;
  LocalAuthExceptionCode? _lastExceptionCode;

  BiometricService(this._auth);

  LocalAuthExceptionCode? get lastExceptionCode => _lastExceptionCode;

  Future<bool> canCheck() async {
    final canCheck = await _auth.canCheckBiometrics;
    final supported = await _auth.isDeviceSupported();
    final available = await _auth.getAvailableBiometrics();
    return canCheck && supported && available.isNotEmpty;
  }

  Future<bool> authenticate() async {
    final now = DateTime.now();
    if (_uiUnavailableRetryAfter != null &&
        now.isBefore(_uiUnavailableRetryAfter!)) {
      debugPrint("BIO: authenticate() blocked due to recent uiUnavailable");
      _lastExceptionCode = LocalAuthExceptionCode.uiUnavailable;
      return false;
    }

    if (_isAuthenticating) {
      debugPrint("BIO: authenticate() ignored, already in progress");
      return false;
    }

    debugPrint("BIO: authenticate() called");
    _isAuthenticating = true;
    try {
      final ok = await _auth.authenticate(
        localizedReason: "Unlock BloodLink with biometrics",
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      _lastExceptionCode = null;
      debugPrint("BIO: authenticate() result=$ok");
      return ok;
    } on LocalAuthException catch (e) {
      _lastExceptionCode = e.code;
      if (e.code == LocalAuthExceptionCode.uiUnavailable) {
        _uiUnavailableRetryAfter = DateTime.now().add(
          const Duration(seconds: 3),
        );
      }
      debugPrint("BIO: LocalAuthException code=${e.code}");
      return false;
    } catch (e) {
      _lastExceptionCode = null;
      debugPrint("BIO: unknown error: $e");
      return false;
    } finally {
      _isAuthenticating = false;
    }
  }
}
