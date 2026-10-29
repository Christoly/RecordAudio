import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.libraryTitle)),
      body: Center(child: Text(l10n.libraryEmpty)),
    );
  }
}