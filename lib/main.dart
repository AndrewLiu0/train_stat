// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:collection/collection.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

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
  late final IOWebSocketChannel _channel;

  List<String> stations = [];
  //String resultTime = "";

  String receivedMessage = "not received";

  void handleReceivedMessage(String message) {
  setState(() {
    receivedMessage = message;
  });
}


  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect('ws://localhost:8888');
    _channel.stream.listen((data){
      setState((){
        receivedMessage = data;
        // var response = json.decode(data);
        // // resultTime = response['time'];
        // String message = response['message'];
        // handleReceivedMessage(message);
      });
    });
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
            _showButton
                ? ElevatedButton(
                    onPressed: () {
                      
                      if(myLocation.isNotEmpty && destination.isNotEmpty){
                        sendMessage();
                        _showButton = true;
                        setState((){
                          _showButton = true;
                        });
                      }
                    },
                    child: const Text("Calculate a Different Route"),
                  )
                : const SizedBox.shrink(),
            Text(
              'Received Time: $receivedMessage',
              
              style: TextStyle(fontSize: 18),
            ),
            

            
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

  void sendMessage() {
    if (myLocation != "" && destination != "") {
      var message =
          json.encode({'location': myLocation, 'destination': destination});
      _channel.sink.add(message);
    }
    
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
