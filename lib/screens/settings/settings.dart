import 'dart:io' show Platform;
import 'package:calculadora/theme/theme.dart';
import 'package:calculadora/widgets/settings/about.dart';
import 'package:calculadora/widgets/settings/dynamic_colors.dart';
import 'package:calculadora/widgets/settings/review.dart';
import 'package:calculadora/widgets/settings/support.dart';
import 'package:calculadora/widgets/settings/theme.dart';
import 'package:flutter/material.dart';
import 'package:calculadora/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAndroid12 = false;

  @override
  void initState() {
    super.initState();
    _checkAndroidVersion();
  }

  Future<void> _checkAndroidVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final version = androidInfo.version.sdkInt;
      setState(() {
        _isAndroid12 = version >= 31;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSectionCard(
            context,
            Column(
              children: [
                ThemeSettings(themeModel: themeModel),
                if (_isAndroid12) const DynamicColorsSettings(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildSectionCard(
            context,
            Column(
              children: [
                buildReviewSettings(context),
                buildSupportSettings(context),
              ],
            ),
          ),
          _buildSectionCard(
            context,
            Column(children: [buildAboutSettings(context)]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, Widget child) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).listTileTheme.tileColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [child],
      ),
    );
  }
}
