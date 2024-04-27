import 'dart:io';
import 'package:calculadora/telas/sobre/sobre.dart';
import 'package:calculadora/tema/tema.dart';
import 'package:calculadora/updater/updater.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        children: [
          _buildCategoryHeader(
              AppLocalizations.of(context)!.interface, Icons.palette_outlined),
          _buildThemeSettings(context, themeModel),
          _buildDynamicColors(themeModel),
          _buildCategoryHeader(
              AppLocalizations.of(context)!.outhers, Icons.more_horiz_outlined),
          _buildUpdateSettings(),
          _buildReview(),
          _buildSupportSettings(),
          _buildAboutSettings(),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeModel themeModel) {
    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(appLocalizations.themeSelect),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<ThemeModeType>(
                      title: Text(appLocalizations.lightMode),
                      value: ThemeModeType.light,
                      groupValue: themeModel.themeMode,
                      onChanged: (value) {
                        setState(() {
                          themeModel.changeThemeMode(value!);
                        });
                        Navigator.pop(context);
                      },
                    ),
                    RadioListTile<ThemeModeType>(
                      title: Text(appLocalizations.darkMode),
                      value: ThemeModeType.dark,
                      groupValue: themeModel.themeMode,
                      onChanged: (value) {
                        setState(() {
                          themeModel.changeThemeMode(value!);
                        });
                        Navigator.pop(context);
                      },
                    ),
                    RadioListTile<ThemeModeType>(
                      title: Text(appLocalizations.systemMode),
                      value: ThemeModeType.system,
                      groupValue: themeModel.themeMode,
                      onChanged: (value) {
                        setState(() {
                          themeModel.changeThemeMode(value!);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
  }

  Widget _buildThemeSettings(BuildContext context, ThemeModel themeModel) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(AppLocalizations.of(context)!.theme),
        subtitle: Text(AppLocalizations.of(context)!.themeSub),
        onTap: () {
          _showThemeDialog(context, themeModel);
        },
      ),
    );
  }

  Widget _buildDynamicColors(ThemeModel themeModel) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(AppLocalizations.of(context)!.dynamicColors),
        subtitle: Text(
          AppLocalizations.of(context)!.dynamicColorsSub,
        ),
        trailing: Switch(
          activeColor: Colors.blue,
          value: themeModel.isDynamicColorsEnabled,
          onChanged: (value) {
            themeModel.toggleDynamicColors();
            themeModel.saveDynamicPreference(value);
          },
        ),
      ),
    );
  }

  Widget _buildUpdateSettings() {
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

  Widget _buildSupportSettings() {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.support,
        ),
        subtitle: Text(
          AppLocalizations.of(context)!.supportSub,
        ),
        leading: const Icon(Icons.support_outlined),
        onTap: () {
          BetterFeedback.of(context).show((feedback) async {
            final screenshotFilePath =
                await writeImageToStorage(feedback.screenshot);

            final Email email = Email(
              body: feedback.text,
              // ignore: use_build_context_synchronously
              subject: AppLocalizations.of(context)!.appName,
              recipients: ['hendrilmendes2015@gmail.com'],
              attachmentPaths: [screenshotFilePath],
              isHTML: false,
            );
            await FlutterEmailSender.send(email);
          });
        },
      ),
    );
  }

  Widget _buildReview() {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(AppLocalizations.of(context)!.review),
        subtitle: Text(AppLocalizations.of(context)!.reviewSub),
        leading: const Icon(Icons.rate_review_outlined),
        onTap: () async {
          final InAppReview inAppReview = InAppReview.instance;

          if (await inAppReview.isAvailable()) {
            inAppReview.requestReview();
          }
        },
      ),
    );
  }

  Widget _buildAboutSettings() {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.about,
        ),
        subtitle: Text(AppLocalizations.of(context)!.aboutSub),
        leading: const Icon(Icons.info_outlined),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutPage()),
          );
        },
      ),
    );
  }
}
