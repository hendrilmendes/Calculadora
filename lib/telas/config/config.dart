import 'dart:io';
import 'package:calculadora/telas/sobre/sobre.dart';
import 'package:calculadora/tema/tema.dart';
import 'package:calculadora/updater/updater.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion = '';
  String appBuild = '';
  String authorApp = '';
  String descApp = '';

  // Metodo para exibir a versao
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
        appBuild = packageInfo.buildNumber;
        authorApp = "Hendril Mendes";
        descApp =
            "Um projeto amador para um app de notícias que usa a API do Blogger";
      });
    });

  }

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
        title: const Text("Ajustes"),
      ),
      body: ListView(
        children: [
          _buildCategoryHeader("Interface", Icons.palette_outlined),
          _buildThemeSettings(themeModel),
          _buildDynamicColors(themeModel),
          _buildCategoryHeader("Outros", Icons.more_horiz_outlined),
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

  Widget _buildThemeSettings(ThemeModel themeModel) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: const Text("Modo Escuro"),
        subtitle: const Text(
          "O modo escuro possibilita uma experiência melhor ao usar o app em ambientes noturnos",
        ),
        trailing: Switch(
          activeColor: Colors.blue,
          value: themeModel.isDarkMode,
          onChanged: (value) {
            themeModel.toggleDarkMode();
            themeModel.saveThemePreference(value);
          },
        ),
      ),
    );
  }

  Widget _buildDynamicColors(ThemeModel themeModel) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: const Text("Dynamic Colors"),
        subtitle: const Text(
          "O Dynamic Colors proporciona uma interface agradável de acordo com o seu papel de parede (Android 12+)",
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
        title: const Text("Atualizações"),
        subtitle: const Text("Toque para buscar por novas versões do app"),
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
        title: const Text(
          "Suporte",
        ),
        subtitle: const Text(
          "Encontrou um bug ou deseja sugerir algo? Entre em contato conosco 😁",
        ),
        leading: const Icon(Icons.support_outlined),
        onTap: () {
          BetterFeedback.of(context).show((feedback) async {
            final screenshotFilePath =
                await writeImageToStorage(feedback.screenshot);

            final Email email = Email(
              body: feedback.text,
              subject: 'Calculadora',
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
        title: const Text("Avalie o App"),
        subtitle: const Text("Faça uma avaliação do nosso app"),
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
        title: const Text("Sobre"),
        subtitle: const Text("Um pouco mais sobre o app"),
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
