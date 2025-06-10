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
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Ex01'),
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
  bool _changeName = true;

  void _printMessage() {
    setState(() {
      debugPrint('Button pressed');
      _changeName = !_changeName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Center(
                child: Text(_changeName ? 'A Simple text' : 'Hello World'),
              ),
            ),
            ElevatedButton(
              onPressed: _printMessage,
              child: const Text('Click me'),
            ),
          ],
        ),
      ),
    );
  }
}
