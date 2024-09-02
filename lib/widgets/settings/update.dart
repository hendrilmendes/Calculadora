import 'package:calculadora/updater/updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildUpdateSettings(BuildContext context) {
  return Card(
    clipBehavior: Clip.hardEdge,
    margin: const EdgeInsets.all(8.0),
    child: ListTile(
      title: Text(AppLocalizations.of(context)!.update),
      subtitle: Text(AppLocalizations.of(context)!.updateSub),
      leading: const Icon(Icons.update_outlined),
      onTap: () {
        Updater.checkForUpdates(context);
      },
    ),
  );
}