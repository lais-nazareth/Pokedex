import 'package:flutter/material.dart';
import 'package:pokedex_app/pages/arguments.dart';

class Lista extends StatefulWidget {
  static String routeName = '/lista';
  String endpoint = '';

  Lista();

  Lista.endpoint(this.endpoint);

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Arguments;

    return Scaffold(
      body: Text("Url: ${args.message}"),
    );
  }
}