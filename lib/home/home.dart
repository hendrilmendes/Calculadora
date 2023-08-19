import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculadora/botoes/botoes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userInput = '';
  var answer = '';

  // Array of button
  final List<String> buttons = [
    'C',
    '+/-',
    '%',
    'DEL',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora"),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Card(
            child: Column(children: <Widget>[
              Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.centerRight,
                child: Text(
                  userInput,
                  style: const TextStyle(fontSize: 60, color: Colors.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                child: Text(
                  answer,
                  style: const TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            ]),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 2,
            child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  // Clear Button
                  if (index == 0) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput = '';
                          answer = '0';
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  }

                  // +/- button
                  else if (index == 1) {
                    return MyButton(
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  }
                  // % Button
                  else if (index == 2) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  }
                  // Delete Button
                  else if (index == 3) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput = userInput.substring(0);
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  }
                  // Equal_to Button
                  else if (index == 18) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          equalPressed();
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.orange[700],
                      textColor: Colors.white,
                    );
                  }

                  //  other buttons
                  else {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: isOperator(buttons[index])
                          ? Colors.blueAccent
                          : Colors.blue[50],
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : Colors.black,
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
  }
}
