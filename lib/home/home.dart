import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import 'package:calculadora/tema/tema.dart';

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

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _clearInput();
      } else if (buttonText == '=') {
        _calculateResult();
      } else {
        _input += buttonText;
      }
    });
  }

  void _clearInput() {
    _input = '';
    _result = 0.0;
  }

  void _calculateResult() {
    try {
      Parser p = Parser();

      Expression exp = p.parse(_input.replaceAll(',', '.'));
      ContextModel cm = ContextModel();
      _result = exp.evaluate(EvaluationType.REAL, cm);
      _history.add(_input);
      _input = '';
    } catch (e) {
      _result = 0.0;
      _input = "Expressão Inválida";
    }
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  Widget _buildDecimalButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(','),
        child: const Text(
          ',',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora',
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.blue,
            icon: Icon(
              themeModel.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: themeModel.toggleDarkMode,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_history.isNotEmpty)
            const Text(
              "Histórico",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _history[index],
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_history.isNotEmpty) const Divider(),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _input,
              style: const TextStyle(
                fontSize: 36.0,
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
                  : _result.toString(),
              style: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('/'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('*'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onButtonPressed('C'),
                    child: const Text(
                      'C',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
                _buildButton('0'),
                _buildButton('='),
                _buildDecimalButton(),
                _buildButton('+'),
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
