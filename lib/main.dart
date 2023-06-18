// ignore_for_file: unused_local_variable, unused_import

//import 'package:web_socket_channel/web_socket_channel.dart';
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
void main() {
  //runApp(const MyApp());
  runApp(const TestApp());
}

// ignore: must_be_immutable whatever that means
class GetInputs extends StatelessWidget {
  String purpose;
  GetInputs(this.purpose,
      {super.key}); //used super.key if I want it from parent class

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250,
        child: TextField(
            obscureText: false,
            decoration: InputDecoration(
                border: const OutlineInputBorder(), labelText: purpose)));
  }

  String getInput() {
    return textController.text;
  }
}
/*
class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}
*/

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;
  Widget build(BuildContext context){
     return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
  }
*/
// ignore: non_constant_identifier_names

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        /* This creates a dropdown */
        home: Scaffold(
            appBar: AppBar(title: const Text('Destination Time')),
            body: Center(
                child: Column(children: [
              const SizedBox(height: 50),
              GetInputs("My Location"),
              const SizedBox(height: 10),
              GetInputs("Destination"),
              //const DropdownButtonExample(),
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  disabledItemFn: (String s) => s.startsWith('I'),
                ),
                items: const [
                  "Brazil",
                  "Italia (Disabled)",
                  "Tunisia",
                  'Canada'
                ],
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Menu mode",
                    hintText: "country in menu mode",
                  ),
                ),
                onChanged: print,
                selectedItem: "Brazil",
              ),

              DropdownSearch<String>.multiSelection(
                items: const [
                  "Brazil",
                  "Italia (Disabled)",
                  "Tunisia",
                  'Canada'
                ],
                popupProps: PopupPropsMultiSelection.menu(
                  showSelectedItems: true,
                  disabledItemFn: (String s) => s.startsWith('I'),
                ),
                onChanged: print,
                selectedItems: const ["Brazil"],
              )
            ]))));
  }
}
