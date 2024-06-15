
import 'package:calculadora/logic/logic.dart';
import 'package:calculadora/screens/history/history.dart';
import 'package:calculadora/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      }
    });
  }

  bool _isOperation(String buttonText) {
    return ['÷', '*', '-', '+', '%'].contains(buttonText);
  }

  Widget _buildButton(String buttonText) {
    final bool isEqualButton = buttonText == '=';
    final bool isOperationButton = _isOperation(buttonText);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: isEqualButton ? Colors.blue : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            textStyle: const TextStyle(fontSize: 24.0),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          ),
          child: buttonText == 'DEL'
              ? const Icon(
                  Icons.backspace_outlined,
                  color: Colors.blue,
                  size: 24.0,
                )
              : Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: isOperationButton && !isEqualButton
                        ? Colors.blue
                        : null,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDecimalButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(','),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            textStyle: const TextStyle(fontSize: 24.0),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          ),
          child: const Text(
            ',',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appName,
          style: const TextStyle(
            fontSize: 24.0,
          ),
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
                Row(
                  children: [
                    _buildButton('AC'),
                    _buildButton('DEL'),
                    _buildButton('%'),
                    _buildButton('÷'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('*'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0'),
                    _buildDecimalButton(),
                    _buildButton('='),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
