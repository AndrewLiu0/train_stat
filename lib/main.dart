import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'String Input Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StringInputScreen(),
    );
  }
}

class StringInputScreen extends StatefulWidget {
  @override
  _StringInputScreenState createState() => _StringInputScreenState();
}

class _StringInputScreenState extends State<StringInputScreen> {
  String enteredString1 = '';
  String enteredString2 = '';

  void updateEnteredString1(String text) {
    setState(() {
      enteredString1 = text;
    });
  }

  void updateEnteredString2(String text) {
    setState(() {
      enteredString2 = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('String Input Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (text) => updateEnteredString1(text),
              decoration: InputDecoration(labelText: 'Enter String 1'),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (text) => updateEnteredString2(text),
              decoration: InputDecoration(labelText: 'Enter String 2'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Process the entered strings as needed
                print('String 1: $enteredString1');
                print('String 2: $enteredString2');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
