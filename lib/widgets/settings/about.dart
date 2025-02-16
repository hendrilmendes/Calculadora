import 'package:calculadora/screens/about/about.dart';
import 'package:flutter/material.dart';
import 'package:calculadora/l10n/app_localizations.dart';

Widget buildAboutSettings(BuildContext context) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.about),
    subtitle: Text(AppLocalizations.of(context)!.aboutSub),
    leading: const Icon(Icons.info_outlined),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutPage()),
      );
    },
  );
}
