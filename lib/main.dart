import 'package:calculadora/firebase_options.dart';
import 'package:calculadora/telas/home/home.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:calculadora/tema/tema.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(BetterFeedback(
    theme: FeedbackThemeData.light(),
    darkTheme: FeedbackThemeData.dark(),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalFeedbackLocalizationsDelegate(),
    ],
    localeOverride: const Locale('pt'),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (_, theme, __) {
          return DynamicColorBuilder(
              builder: (lightColorScheme, darkColorScheme) {
            if (!theme.isDynamicColorsEnabled) {
              lightColorScheme = null;
              darkColorScheme = null;
            }

            return MaterialApp(
              theme: ThemeData(
                brightness: Brightness.light,
                colorScheme: lightColorScheme?.copyWith(
                  primary: theme.isDarkMode ? Colors.black : Colors.black,
                ),
                useMaterial3: true,
                textTheme: Typography().black.apply(),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                colorScheme: darkColorScheme?.copyWith(
                  primary: theme.isDarkMode ? Colors.white : Colors.black,
                ),
                useMaterial3: true,
                textTheme: Typography().white.apply(),
              ),
              themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: const HomePage(),
            );
          });
        },
      ),
    );
  }
}
