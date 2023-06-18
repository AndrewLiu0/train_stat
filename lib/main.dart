// ignore_for_file: unused_local_variable, unused_import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:convert' show utf8;
import 'package:web_socket_channel/web_socket_channel.dart';

final channel = WebSocketChannel.connect(
  Uri.parse('wss://echo.websocket.events'),
);
const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
String myLocation = "";
String destination = "";
void main() {
  //runApp(const MyApp());

  runApp(
    const MaterialApp(
      home: TestApp()
    )
  );
}



class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transit App"),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(60),
        child: SizedBox(
          height: 150,
          child: ListView(
            children: [
              createDropdown("My Location", "myLocation"),
              const SizedBox(height: 20),
              createDropdown("Destination", "destination"),
            ],
          ),
        )
      )
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
        throw const FormatException("Invalid input type");
    }
  }


  return DropdownSearch<String>(
    popupProps: const PopupProps.menu(
      showSelectedItems:  true,
      showSearchBox: true,
      searchFieldProps: TextFieldProps(
        cursorColor: Colors.blue,// can add other customization later
      )
    ),

    items: const [
      "a", 
      "b",
      "c", 
      "carbine" // make these the train stations
    ],

    dropdownDecoratorProps: DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        labelText: label,
        hintText: "Find your station ... " 
      )
    ),
    
    onChanged: _inputType,
  );
}
}