enum RecorderStatus { idle, recording, paused }

enum RecorderError {
  permissionDenied,
  startFailed,
  stopFailed,
  lowStorage,
  storageStopped,
}

class RecorderState {
  const RecorderState({
    this.status = RecorderStatus.idle,
    this.elapsed = Duration.zero,
    this.levels = const [],
    this.error,
    this.lastSavedPath,
  });

  final RecorderStatus status;
  final Duration elapsed;

  /// Niveaux sonores normalisés entre 0 et 1, du plus ancien au plus récent.
  final List<double> levels;
  final RecorderError? error;
  final String? lastSavedPath;

  RecorderState copyWith({
    RecorderStatus? status,
    Duration? elapsed,
    List<double>? levels,
    RecorderError? error,
    bool clearError = false,
    String? lastSavedPath,
  }) {
    return RecorderState(
      status: status ?? this.status,
      elapsed: elapsed ?? this.elapsed,
      levels: levels ?? this.levels,
      error: clearError ? null : (error ?? this.error),
      lastSavedPath: lastSavedPath ?? this.lastSavedPath,
    );
  }
}