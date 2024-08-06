import 'package:flutter/material.dart';

class CalculatorButtons extends StatelessWidget {
  final void Function(String) onButtonPressed;

  const CalculatorButtons({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }

  Widget _buildButton(String buttonText) {
    final bool isEqualButton = buttonText == '=';
    final bool isOperationButton = _isOperation(buttonText);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(buttonText),
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
          onPressed: () => onButtonPressed(','),
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

  bool _isOperation(String buttonText) {
    return ['÷', '*', '-', '+', '%'].contains(buttonText);
  }
}
