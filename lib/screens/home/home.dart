import 'package:calculadora/logic/logic.dart';
import 'package:calculadora/screens/history/history.dart';
import 'package:calculadora/screens/settings/settings.dart';
import 'package:calculadora/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:calculadora/l10n/app_localizations.dart';
import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _input = '';
  double _result = 0.0;
  final List<String> _history = [];
  bool _isLastButtonEqual = false;
  bool _isScientific = false;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        CalculatorLogic.clearInput(
          context: context,
          input: _input,
          setInput: (value) => _input = value,
          setResult: (value) => _result = value,
          setIsLastButtonEqual: (value) => _isLastButtonEqual = value,
        );
      } else if (buttonText == '=') {
        if (_input.isNotEmpty) {
          CalculatorLogic.calculateResult(
            context: context,
            input: _input,
            setInput: (value) => _input = value,
            setResult: (value) => _result = value,
            history: _history,
            setIsLastButtonEqual: (value) => _isLastButtonEqual = value,
          );
        }
      } else if (buttonText == 'DEL') {
        CalculatorLogic.deleteLastCharacter(
          input: _input,
          setInput: (value) => _input = value,
        );
      } else {
        if (_isLastButtonEqual) {
          if (_isOperation(buttonText)) {
            _input = _result.toString();
          } else {
            _input = '';
          }
          _isLastButtonEqual = false;
        }
        buttonText = buttonText == '÷' ? '/' : buttonText;
        _input += buttonText;
        // Calcula o resultado enquanto o usuário digita
        try {
          String formattedInput = _input.replaceAll(',', '.');
          // ignore: deprecated_member_use
          Parser p = Parser();
          Expression exp = p.parse(formattedInput);
          ContextModel cm = ContextModel();
          double evalResult = exp.evaluate(EvaluationType.REAL, cm);
          _result = evalResult;
        } catch (e) {
          _result = 0.0;
        }
      }
    });
  }

  bool _isOperation(String buttonText) {
    return ['÷', '*', '-', '+', '%'].contains(buttonText);
  }

  void _toggleScientificMode() {
    setState(() {
      _isScientific = !_isScientific;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appName,
          style: const TextStyle(fontSize: 24.0),
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                child: Text(AppLocalizations.of(context)!.history),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(history: _history),
                    ),
                  );
                },
              ),
              PopupMenuItem<int>(
                child: Text(AppLocalizations.of(context)!.settings),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _input,
                    style: const TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _result == _result.toInt()
                        ? _result.toInt().toString()
                        : _result.toString().replaceAll('.', ','),
                    style: const TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                CalculatorButtons(
                  onButtonPressed: _onButtonPressed,
                  isScientific: _isScientific,
                  onToggleScientificMode: _toggleScientificMode,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
