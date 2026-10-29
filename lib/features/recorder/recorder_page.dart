import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'recorder_controller.dart';
import 'recorder_state.dart';
import '../../core/service/foreground_service.dart';

class RecorderPage extends ConsumerWidget {
  const RecorderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(recorderControllerProvider);
    final controller = ref.read(recorderControllerProvider.notifier);

    ref.listen<RecorderState>(recorderControllerProvider, (previous, next) {
      final messenger = ScaffoldMessenger.of(context);
      if (next.error != null && next.error != previous?.error) {
                final message = switch (next.error!) {
          RecorderError.permissionDenied => l10n.micPermissionRequired,
          RecorderError.startFailed => l10n.errorStartFailed,
          RecorderError.stopFailed => l10n.errorStopFailed,
          RecorderError.lowStorage => l10n.errorLowStorage,
          RecorderError.storageStopped => l10n.errorStorageStopped,
        };
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
        controller.clearError();
      } else if (next.lastSavedPath != null &&
          next.lastSavedPath != previous?.lastSavedPath) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.recorderSaved)));
      }
    });

    final statusLabel = switch (state.status) {
      RecorderStatus.idle => l10n.recorderIdle,
      RecorderStatus.recording => l10n.recorderRecording,
      RecorderStatus.paused => l10n.recorderPaused,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recorderTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Text(
                _formatDuration(state.elapsed),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Text(statusLabel, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 32),
              SizedBox(
                height: 96,
                width: double.infinity,
                child: CustomPaint(
                  painter: _WaveformPainter(
                    levels: state.levels,
                    maxBars: 64,
                    color: state.status == RecorderStatus.recording
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
              const Spacer(),
              _Controls(state: state, controller: controller),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.state, required this.controller});

  final RecorderState state;
  final RecorderController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final texts = NotificationTexts(
      channelName: l10n.notifChannelName,
      title: l10n.appTitle,
      recording: l10n.recorderRecording,
      paused: l10n.recorderPaused,
    );

    if (state.status == RecorderStatus.idle) {
      return FilledButton.icon(
        onPressed: () => controller.start(texts),
        icon: const Icon(Icons.mic_rounded),
        label: Text(l10n.actionStart),
        style: FilledButton.styleFrom(
          minimumSize: const Size(200, 64),
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    final isRecording = state.status == RecorderStatus.recording;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.tonalIcon(
          onPressed: isRecording ? controller.pause : controller.resume,
          icon: Icon(
            isRecording ? Icons.pause_rounded : Icons.play_arrow_rounded,
          ),
          label: Text(isRecording ? l10n.actionPause : l10n.actionResume),
          style: FilledButton.styleFrom(minimumSize: const Size(150, 60)),
        ),
        const SizedBox(width: 16),
        FilledButton.icon(
          onPressed: controller.stop,
          icon: const Icon(Icons.stop_rounded),
          label: Text(l10n.actionStop),
          style: FilledButton.styleFrom(
            minimumSize: const Size(150, 60),
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
        ),
      ],
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.levels,
    required this.maxBars,
    required this.color,
  });

  final List<double> levels;
  final int maxBars;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final step = size.width / maxBars;
    final paint = Paint()
      ..color = color
      ..strokeWidth = step * 0.55
      ..strokeCap = StrokeCap.round;
    final midY = size.height / 2;

    // Le niveau le plus récent est à droite.
    for (var i = 0; i < levels.length; i++) {
      final x = size.width - (levels.length - i) * step + step / 2;
      final half = (levels[i] * size.height).clamp(4.0, size.height) / 2;
      canvas.drawLine(Offset(x, midY - half), Offset(x, midY + half), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter old) =>
      old.levels != levels || old.color != color;
}

String _formatDuration(Duration d) {
  String two(int n) => n.toString().padLeft(2, '0');
  final h = d.inHours;
  final m = two(d.inMinutes.remainder(60));
  final s = two(d.inSeconds.remainder(60));
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}