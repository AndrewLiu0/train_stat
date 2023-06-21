// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:collection/collection.dart';
import 'dart:convert' show utf8;
import 'package:web_socket_channel/web_socket_channel.dart';

/*
StreamBuilder(
  stream: channel.stream,
  builder: (context, snapshot) {
    return Text(snapshot.hasData ? '${snapshot.data}' : '');
  },
)
*/
String myLocation = "";
String destination = "";

void main() {
  runApp(MaterialApp(
    home: TestApp(),
    theme: ThemeData(
      primaryColor: Colors.blue, // Set your desired primary color
    ),
  ));
}

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );
  String myLocation = "";
  String destination = "";
  List<String> stations = [];

  void initState() {
    super.initState();
    loadStations();
  }

  Future<void> loadStations() async {
    final fileContents = await rootBundle.loadString('assets/stops.txt');
    final csvTable = const CsvToListConverter().convert(fileContents);

    setState(() {
      stations = csvTable
          .where((row) => row.length >= 3)
          .map((row) => row[2] as String)
          .toList();
      stations =
          stations.whereIndexed((index, _) => (index - 1) % 3 == 0).toList();
    });

    stations.removeAt(0);
  }

  bool _showButton = false;
  void changeStatus() {
    setState(() {
      _showButton = !_showButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Colors.blue, // Set your desired button background color
      minimumSize: const Size(200, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transit App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            createDropdown("My Location", "myLocation"),
            const SizedBox(height: 20),
            createDropdown("Destination", "destination"),
            const SizedBox(height: 20),
            ElevatedButton(
              style: flatButtonStyle,
              onPressed: sendMessage,
              child: const Text('Calculate Time Between Stations'),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (!_showButton) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 20),
            _showButton
                ? ElevatedButton(
                    onPressed: changeStatus,
                    child: const Text("Calculate a Different Route"),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  DropdownSearch<String> createDropdown(String label, String inputType) {
    void _inputType(String? station) {
      switch (inputType) {
        case "myLocation":
          myLocation = station as String;
          break;
        case "destination":
          destination = station as String;
          break;
        default:
          throw FormatException("Invalid input type");
      }
    }

    return DropdownSearch<String>(
      popupProps: const PopupProps.menu(
        showSelectedItems: true,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          cursorColor: Colors.blue,
        ),
      ),
      items: stations,
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
              labelText: label, hintText: "Find your station ... ")),
      onChanged: _inputType,
    );
  }

/*
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
  */
  void sendMessage() {
    if (myLocation != "" && destination != "") {
      _channel.sink.add(myLocation);
      _channel.sink.add(destination);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
