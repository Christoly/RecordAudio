import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class StorageService {
  /// Octets libres, ou null si la valeur est inconnue.
  Future<int?> freeBytes();
}

class PlatformStorageService implements StorageService {
  static const _channel =
      MethodChannel('com.christoly.audio_recorder_app/storage');

  @override
  Future<int?> freeBytes() async {
    try {
      return await _channel.invokeMethod<int>('getFreeBytes');
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}

final storageServiceProvider =
    Provider<StorageService>((ref) => PlatformStorageService());