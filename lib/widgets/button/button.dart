import 'package:flutter/material.dart';

class CalculatorButtons extends StatelessWidget {
  final void Function(String) onButtonPressed;
  final bool isScientific;
  final VoidCallback onToggleScientificMode;

  const CalculatorButtons({
    super.key,
    required this.onButtonPressed,
    required this.isScientific,
    required this.onToggleScientificMode,
  });

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
        if (isScientific) ...[
          Row(
            children: [
              _buildButton('sin'),
              _buildButton('cos'),
              _buildButton('tan'),
              _buildButton('log'),
            ],
          ),
          Row(
            children: [
              _buildButton('√'),
              _buildButton('^'),
              _buildButton('('),
              _buildButton(')'),
            ],
          ),
        ],
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
            _buildToggleButton(),
            _buildButton('0'),
            _buildDecimalButton(),
            _buildButton('='),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButton() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(isScientific ? 1.0 : 2.0),
        child: ElevatedButton(
          onPressed: onToggleScientificMode,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            textStyle: TextStyle(fontSize: isScientific ? 16.0 : 18.0),
            padding: EdgeInsets.symmetric(vertical: isScientific ? 12.0 : 20.0),
          ),
          child: Icon(
            isScientific ? Icons.science_outlined : Icons.calculate_outlined,
            size: isScientific ? 20.0 : 24.0,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(isScientific ? 1.0 : 2.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            textStyle: TextStyle(fontSize: isScientific ? 20.0 : 24.0),
            padding: EdgeInsets.symmetric(vertical: isScientific ? 12.0 : 20.0),
          ),
          child: buttonText == 'DEL'
              ? Icon(
                  Icons.backspace_outlined,
                  size: isScientific ? 20.0 : 24.0,
                )
              : Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: isScientific ? 20.0 : 24.0,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDecimalButton() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(isScientific ? 1.0 : 2.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(','),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            textStyle: TextStyle(fontSize: isScientific ? 20.0 : 24.0),
            padding: EdgeInsets.symmetric(vertical: isScientific ? 12.0 : 20.0),
          ),
          child: Text(
            ',',
            style: TextStyle(fontSize: isScientific ? 20.0 : 24.0),
          ),
        ),
      ),
    );
  }
}
