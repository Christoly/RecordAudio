import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Textes de la notification, déjà traduits (fournis par l'interface).
class NotificationTexts {
  const NotificationTexts({
    required this.channelName,
    required this.title,
    required this.recording,
    required this.paused,
  });

  final String channelName;
  final String title;
  final String recording;
  final String paused;
}

abstract class ForegroundService {
  /// Démarre le service, ou met à jour la notification s'il tourne déjà.
  Future<void> show(NotificationTexts texts, {required bool paused});
  Future<void> hide();
}

class PlatformForegroundService implements ForegroundService {
  static const _channel =
      MethodChannel('com.christoly.audio_recorder_app/service');

  @override
  Future<void> show(NotificationTexts texts, {required bool paused}) {
    return _channel.invokeMethod<void>('show', {
      'channelName': texts.channelName,
      'title': texts.title,
      'text': paused ? texts.paused : texts.recording,
    });
  }

  @override
  Future<void> hide() async {
    try {
      await _channel.invokeMethod<void>('hide');
    } on PlatformException {
      // Rien à faire : le service est peut-être déjà arrêté.
    }
  }
}

final foregroundServiceProvider =
    Provider<ForegroundService>((ref) => PlatformForegroundService());