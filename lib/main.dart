import 'package:flutter/material.dart';
import 'package:calculadora/tema/tema.dart';
import 'package:calculadora/home/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (_, theme, __) {
          return MaterialApp(
            theme: ThemeData.light(useMaterial3: true).copyWith(
              textTheme: Typography().black,
            ),
            darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              textTheme: Typography().white,
            ),
            themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
