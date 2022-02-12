import 'package:flutter/material.dart';
import 'package:gerenciador_de_contas/src/Home.dart';


void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      hintColor: Colors.grey,
      primaryColor: Colors.blueAccent,
      primarySwatch: Colors.green,
    ),
  ));
}
