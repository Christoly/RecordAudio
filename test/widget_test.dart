import 'package:audio_recorder_app/app.dart';
import 'package:audio_recorder_app/core/settings/settings_providers.dart';
import 'package:audio_recorder_app/core/storage/storage_service.dart';
import 'package:audio_recorder_app/features/recorder/recorder_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeRecorderService implements RecorderService {
  @override
  Future<bool> hasPermission() async => true;
  @override
  Future<void> start(String path) async {}
  @override
  Future<void> pause() async {}
  @override
  Future<void> resume() async {}
  @override
  Future<String?> stop() async => null;
  @override
  Stream<double> amplitudeDb(Duration interval) => const Stream.empty();
  @override
  Future<void> dispose() async {}
}

class FakeStorageService implements StorageService {
  @override
  Future<int?> freeBytes() async => 1024 * 1024 * 1024;
}

void main() {
  testWidgets('la langue peut être changée dans les réglages', (tester) async {
    SharedPreferences.setMockInitialValues({'language': 'fr'});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          recorderServiceProvider.overrideWithValue(FakeRecorderService()),
          storageServiceProvider.overrideWithValue(FakeStorageService()),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.text('Réglages'));
    await tester.pumpAndSettle();
    expect(find.text('Langue'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Language'), findsOneWidget);
    expect(prefs.getString('language'), 'en');
  });
}