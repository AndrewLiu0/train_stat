import 'package:flutter/material.dart';

void main() {
  //runApp(const MyApp());
  runApp(
    TestApp()
  );
}

// class TransitApp extends StatelessWidget{
//   @override
//   Widget build(BuildContext build){
//     return ; // return the completed widget
//   }
// }

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



class TestApp extends StatelessWidget{
  const TestApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Destination Time')),
        body: Center(
          child:  Column(
            children: [
              SizedBox(height: 50),
              GetInputs("My Location"),
              SizedBox(height: 10),
              GetInputs("Destination")
            ]
          )

        )
      )
    );
  }
}