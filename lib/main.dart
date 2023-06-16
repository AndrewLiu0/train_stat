// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dropdown_search/dropdown_search.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
void main() {
  //runApp(const MyApp());
  runApp(
    TestApp()
  );
}



// ignore: must_be_immutable whatever that means
class GetInputs extends StatelessWidget{

  String purpose;
  GetInputs(this.purpose, {super.key});//used super.key if I want it from parent class

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context){
    
    return SizedBox(
      width:250,
      child: TextField(
        obscureText: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: purpose
        )
      )
    );
  }

  String getInput(){
    return textController.text;
  }

}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

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



class TestApp extends StatelessWidget{
  const TestApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      /* This creates a dropdown */
      home: Scaffold(
        appBar: AppBar(title: const Text('Destination Time')),
        body: Center(
          child:  Column(
            children: [
              SizedBox(height: 50),
              GetInputs("My Location"),
              SizedBox(height: 10),
              GetInputs("Destination"),
              const DropdownButtonExample(),
            ]
          )

        )
      )
    );
  }
}