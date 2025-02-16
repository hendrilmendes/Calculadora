import 'package:calculadora/updater/updater.dart';
import 'package:flutter/material.dart';
import 'package:calculadora/l10n/app_localizations.dart';

Widget buildUpdateSettings(BuildContext context) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.update),
    subtitle: Text(AppLocalizations.of(context)!.updateSub),
    leading: const Icon(Icons.update_outlined),
    tileColor: Theme.of(context).listTileTheme.tileColor,
    onTap: () {
      Updater.checkForUpdates(context);
    },
  );
}
