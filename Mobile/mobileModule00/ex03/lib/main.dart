import 'package:flutter/material.dart';

import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculatrice',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Calculatrice'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Liste des boutons de la calculatrice
  final List<String> _outputValues = [];
  final List<String> buttons = [
    '7',
    '8',
    '9',
    'C',
    'AC',
    '4',
    '5',
    '6',
    '+',
    '-',
    '1',
    '2',
    '3',
    '*',
    '/',
    '0',
    '.',
    '00',
    '=',
  ];

  var printValue = '0';

  void _printCalculator(var text) {
    setState(() {
      if (text == 'C') {
        if (printValue.isNotEmpty) {
          printValue = printValue.substring(0, printValue.length - 1);
          return;
        } else {
          printValue = '0';
          return;
        }
      } else if (text == 'AC') {
        _outputValues.clear();
        printValue = '0';
        return;
      } else if (text == '=') {
        _outputValues.add(mathCalculator());
        debugPrint('$_outputValues');
        printValue = '0';
        return;
      }
      if (printValue == '0') {
        printValue = text;
      } else {
        printValue += text;
      }
    });
  }

  String mathCalculator() {
    try {
      ShuntingYardParser p = ShuntingYardParser();
      Expression exp = p.parse(printValue);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x006a645a),
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(left: 4, right: 20, top: 4, bottom: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    printValue,
                    style: TextStyle(color: Colors.black, fontSize: 36),
                    textAlign: TextAlign.end,
                  ),
                  Expanded(
                    child: ListView(
                      reverse: false,
                      children: _buildOutputTexts(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(children: _buildButtonRows()),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOutputTexts() {
    return _outputValues.reversed
        .map(
          (value) => Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: 36),
            textAlign: TextAlign.end,
          ),
        )
        .toList();
  }

  List<Widget> _buildButtonRows() {
    List<Widget> rows = [];
    for (int i = 0; i < buttons.length; i += 5) {
      rows.add(Expanded(child: Row(children: _buildRow(i))));
    }
    return rows;
  }

  List<Widget> _buildRow(int startIndex) {
    List<Widget> cells = [];
    for (int i = startIndex; i < startIndex + 5 && i < buttons.length; i++) {
      cells.add(Expanded(child: _buildCell(buttons[i])));
    }
    return cells;
  }

  Widget _buildCell(String text) {
    return ElevatedButton(
      onPressed: () {
        debugPrint('button pressed :$text');
        _printCalculator(text);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(6.0),
        backgroundColor: Color(0x006a645a),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        minimumSize: Size(double.infinity, double.infinity),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
