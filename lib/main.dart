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
                border: const OutlineInputBorder(), labelText: purpose
            )
        )
    );
  }

  String getInput() {
    return textController.text;
  }
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

// void _setMyLocation(String? s){
//   myLocation = s as String;
// }

// void _setDestination(String? s){
//   destination = s as String;
// }



// class TestApp extends StatelessWidget {
//   const TestApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         /* This creates a dropdown */
//       home: Scaffold(
//           appBar: AppBar(title: const Text('Destination Time')),
//           body: Center(
//             child: Column(children: [
//             const SizedBox(height: 50),
//             GetInputs("My Location"),
//             const SizedBox(height: 10),
//             GetInputs("Destination"),
//             //const DropdownButtonExample(),
//             DropdownSearch<String>(
//               popupProps: PopupProps.menu(
//                 showSelectedItems: true,
//                 disabledItemFn: (String s) => s.startsWith('I'),
//               ),
//               items: const [
//                 "Brazil",
//                 "Italia (Disabled)",
//                 "Tunisia",
//                 'Canada'
//               ],
//               dropdownDecoratorProps: const DropDownDecoratorProps(
//                 dropdownSearchDecoration: InputDecoration(
//                   labelText: "Menu mode",
//                   hintText: "country in menu mode",
//                 ),
//               ),
//               onChanged: print,
//               selectedItem: "Brazil",
//             ),

//             DropdownSearch<String>.multiSelection(
//               items: const [
//                 "Brazil",
//                 "Italia (Disabled)",
//                 "Tunisia",
//                 'Canada'
//               ],
//               popupProps: PopupPropsMultiSelection.menu(
//                 showSelectedItems: true,
//                 disabledItemFn: (String s) => s.startsWith('I'),
//               ),
//               onChanged: print,
//               selectedItems: const ["Brazil"],
//             )
//             ]
//           )
//         )
//       ) 
//     );
//   }
// }
}