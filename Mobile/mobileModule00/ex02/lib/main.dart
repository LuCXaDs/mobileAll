import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '0',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '0',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: _buildButtonRows()),
            ),
          ),
        ],
      ),
    );
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
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(6.0),
        backgroundColor: Colors.grey[100],
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
