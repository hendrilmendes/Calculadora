import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appVersion = '';
  String appBuild = '';

  // Metodo para exibir a versao
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
        appBuild = packageInfo.buildNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Card(
                    elevation: 15,
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: 80,
                      child: Image(
                        image: AssetImage('assets/img/ic_launcher.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Copyright © Hendril Mendes, 2023-$currentYear',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.copyright,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.appDesc,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  // Versao
                  Card(
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.version),
                      subtitle: Text('v$appVersion Build: ($appBuild)'),
                      leading: const Icon(Icons.calculate_outlined),
                      onTap: () {
                        Navigator.pop(context);
                        launchUrl(
                          Uri.parse(
                            'https://raw.githubusercontent.com/hendrilmendes/Calculadora/main/Changelog.md',
                          ),
                          mode: LaunchMode.inAppBrowserView,
                        );
                      },
                    ),
                  ),
                  // Codigo Fonte
                  Card(
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.sourceCode),
                      subtitle:
                          Text(AppLocalizations.of(context)!.sourceCodeSub),
                      leading: const Icon(Icons.code_outlined),
                      onTap: () {
                        Navigator.pop(context);
                        launchUrl(
                          Uri.parse(
                            'https://github.com/hendrilmendes/Calculadora/',
                          ),
                          mode: LaunchMode.inAppBrowserView,
                        );
                      },
                    ),
                  ),
                  // Licencas
                  Card(
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.openSource),
                      subtitle:
                          Text(AppLocalizations.of(context)!.openSourceSub),
                      leading: const Icon(Icons.folder_open_outlined),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LicensePage(
                              applicationName:
                                  AppLocalizations.of(context)!.appName,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
