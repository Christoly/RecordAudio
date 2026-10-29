import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/service/foreground_service.dart';
import '../../core/storage/storage_service.dart';
import 'recorder_service.dart';
import 'recorder_state.dart';

final recorderControllerProvider =
    NotifierProvider<RecorderController, RecorderState>(
  RecorderController.new,
);

class RecorderController extends Notifier<RecorderState> {
  static const _maxLevels = 64;
  static const _minDb = -60.0;
  static const _minFreeToStart = 50 * 1024 * 1024; // 50 Mo
  static const _minFreeWhileRecording = 10 * 1024 * 1024; // 10 Mo
  static const _storageCheckEveryTicks = 25; // 25 x 200 ms = 5 s

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  StreamSubscription<double>? _amplitudeSub;
  int _ticks = 0;
  NotificationTexts? _texts;

  RecorderService get _recorder => ref.read(recorderServiceProvider);
  ForegroundService get _service => ref.read(foregroundServiceProvider);

  @override
  RecorderState build() {
    ref.onDispose(() async {
      _ticker?.cancel();
      await _amplitudeSub?.cancel();
    });
    return const RecorderState();
  }

  Future<void> start(NotificationTexts texts) async {
    if (state.status != RecorderStatus.idle) return;
    _texts = texts;
    try {
      if (!await _recorder.hasPermission()) {
        state = state.copyWith(error: RecorderError.permissionDenied);
        return;
      }

      final free = await ref.read(storageServiceProvider).freeBytes();
      if (free != null && free < _minFreeToStart) {
        state = state.copyWith(error: RecorderError.lowStorage);
        return;
      }

      // Refuser les notifications ne bloque pas l'enregistrement.
      if (!await Permission.notification.isGranted) {
        await Permission.notification.request();
      }

      final docs = await getApplicationDocumentsDirectory();
      final dir = Directory('${docs.path}/recordings');
      await dir.create(recursive: true);
      final path =
          '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Le service d'abord : Android exige qu'il existe pour garder le micro
      // en arrière-plan.
      await _service.show(texts, paused: false);
      await _recorder.start(path);

      _stopwatch
        ..reset()
        ..start();
      _startTicker();
      _listenToAmplitude();
      state = state.copyWith(
        status: RecorderStatus.recording,
        elapsed: Duration.zero,
        levels: const [],
        clearError: true,
      );
    } catch (_) {
      await _service.hide();
      state = state.copyWith(error: RecorderError.startFailed);
    }
  }

  Future<void> pause() async {
    if (state.status != RecorderStatus.recording) return;
    try {
      await _recorder.pause();
      _stopwatch.stop();
      state = state.copyWith(
        status: RecorderStatus.paused,
        elapsed: _stopwatch.elapsed,
      );
      await _updateNotification(paused: true);
    } catch (_) {
      state = state.copyWith(error: RecorderError.stopFailed);
    }
  }

  Future<void> resume() async {
    if (state.status != RecorderStatus.paused) return;
    try {
      await _recorder.resume();
      _stopwatch.start();
      state = state.copyWith(status: RecorderStatus.recording);
      await _updateNotification(paused: false);
    } catch (_) {
      state = state.copyWith(error: RecorderError.startFailed);
    }
  }

  Future<void> stop() async {
    if (state.status == RecorderStatus.idle) return;
    _ticker?.cancel();
    await _amplitudeSub?.cancel();
    _amplitudeSub = null;
    _stopwatch.stop();
    try {
      final path = await _recorder.stop();
      state = RecorderState(lastSavedPath: path);
    } catch (_) {
      state = const RecorderState(error: RecorderError.stopFailed);
    } finally {
      await _service.hide();
    }
  }

  void clearError() => state = state.copyWith(clearError: true);

  Future<void> _updateNotification({required bool paused}) async {
    final texts = _texts;
    if (texts == null) return;
    try {
      await _service.show(texts, paused: paused);
    } catch (_) {
      // La notification est secondaire : l'enregistrement continue.
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticks = 0;
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (state.status != RecorderStatus.recording) return;
      state = state.copyWith(elapsed: _stopwatch.elapsed);
      _ticks++;
      if (_ticks % _storageCheckEveryTicks == 0) _checkStorage();
    });
  }

  Future<void> _checkStorage() async {
    final free = await ref.read(storageServiceProvider).freeBytes();
    if (free == null || free >= _minFreeWhileRecording) return;
    if (state.status == RecorderStatus.idle) return;
    await stop();
    state = state.copyWith(error: RecorderError.storageStopped);
  }

  void _listenToAmplitude() {
    _amplitudeSub?.cancel();
    _amplitudeSub = _recorder
        .amplitudeDb(const Duration(milliseconds: 80))
        .listen((db) {
      if (state.status != RecorderStatus.recording) return;
      final level = ((db - _minDb) / -_minDb).clamp(0.0, 1.0);
      final levels = [...state.levels, level];
      if (levels.length > _maxLevels) {
        levels.removeRange(0, levels.length - _maxLevels);
      }
      state = state.copyWith(levels: levels);
    });
  }
}