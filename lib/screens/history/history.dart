import 'package:flutter/material.dart';
import 'package:calculadora/l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.history)),
      body: history.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.noHistory,
                style: const TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(history[index]));
              },
            ),
    );
  }
}
