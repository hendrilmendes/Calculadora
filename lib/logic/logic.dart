import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  static void clearInput({
    required BuildContext context,
    required String input,
    required Function(String) setInput,
    required Function(double) setResult,
    required Function(bool) setIsLastButtonEqual,
  }) {
    setInput('');
    setResult(0.0);
    setIsLastButtonEqual(false);
  }

  static void deleteLastCharacter({
    required String input,
    required Function(String) setInput,
  }) {
    if (input.isNotEmpty) {
      setInput(input.substring(0, input.length - 1));
    }
  }

  static void calculateResult({
    required BuildContext context,
    required String input,
    required Function(String) setInput,
    required Function(double) setResult,
    required List<String> history,
    required Function(bool) setIsLastButtonEqual,
  }) {
    try {
      String formattedInput = input.replaceAll(',', '.');

      // Regex para encontrar números seguidos por percentuais (ex: 100-10%)
      formattedInput = formattedInput.replaceAllMapped(
        RegExp(r'(\d+(\.\d+)?)(\s*[-+*/]\s*)(\d+(\.\d+)?)%'),
        (match) {
          String baseNumber = match.group(1)!;
          String operator = match.group(3)!;
          String percentNumber = match.group(4)!;
          double result = double.parse(baseNumber);
          if (operator == "-") {
            result -=
                (double.parse(baseNumber) * double.parse(percentNumber) / 100);
          } else if (operator == "+") {
            result +=
                (double.parse(baseNumber) * double.parse(percentNumber) / 100);
          } else if (operator == "*") {
            result *=
                (double.parse(baseNumber) * double.parse(percentNumber) / 100);
          } else if (operator == "/") {
            result /=
                (double.parse(baseNumber) * double.parse(percentNumber) / 100);
          }
          return result.toString();
        },
      );

      Parser p = Parser();
      Expression exp = p.parse(formattedInput);
      ContextModel cm = ContextModel();
      double evalResult = exp.evaluate(EvaluationType.REAL, cm);

      setResult(evalResult);
      history.add('$input = ${evalResult.toString().replaceAll('.', ',')}');
      setInput('');
      setIsLastButtonEqual(true);
    } catch (e) {
      setResult(0.0);
      setInput(AppLocalizations.of(context)!.invalid);
    }
  }
}
