import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

abstract class RecorderService {
  Future<bool> hasPermission();
  Future<void> start(String path);
  Future<void> pause();
  Future<void> resume();
  Future<String?> stop();

  /// Niveau sonore en dB (de -160 à 0).
  Stream<double> amplitudeDb(Duration interval);
  Future<void> dispose();
}

class RecordPackageService implements RecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  @override
  Future<bool> hasPermission() => _recorder.hasPermission();

  @override
  Future<void> start(String path) => _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: path,
      );

  @override
  Future<void> pause() => _recorder.pause();

  @override
  Future<void> resume() => _recorder.resume();

  @override
  Future<String?> stop() => _recorder.stop();

  @override
  Stream<double> amplitudeDb(Duration interval) =>
      _recorder.onAmplitudeChanged(interval).map((a) => a.current);

  @override
  Future<void> dispose() => _recorder.dispose();
}

final recorderServiceProvider = Provider<RecorderService>((ref) {
  final service = RecordPackageService();
  ref.onDispose(service.dispose);
  return service;
});