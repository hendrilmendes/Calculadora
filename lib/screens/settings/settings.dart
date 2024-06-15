import 'package:calculadora/theme/theme.dart';
import 'package:calculadora/widgets/settings/about.dart';
import 'package:calculadora/widgets/settings/category.dart';
import 'package:calculadora/widgets/settings/dynamic_colors.dart';
import 'package:calculadora/widgets/settings/review.dart';
import 'package:calculadora/widgets/settings/support.dart';
import 'package:calculadora/widgets/settings/theme.dart';
import 'package:calculadora/widgets/settings/update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        ),
      body: ListView(
        children: [
          buildCategoryHeader(
              AppLocalizations.of(context)!.interface, Icons.palette_outlined),
          ThemeSettings(themeModel: themeModel),
          const DynamicColorsSettings(),
          buildCategoryHeader(
              AppLocalizations.of(context)!.outhers, Icons.more_horiz_outlined),
          buildUpdateSettings(context),
          buildReviewSettings(context),
          buildSupportSettings(context),
          buildAboutSettings(context),
        ],
      ),
    );
  }
}
