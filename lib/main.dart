import 'package:flutter/material.dart';
import 'package:pokedex_app/pages/home.dart';
import 'package:pokedex_app/pages/tela_geracao.dart';
import 'package:pokedex_app/pages/tela_habitat.dart';
import 'package:pokedex_app/pages/tela_id.dart';
import 'package:pokedex_app/pages/tela_lista.dart';
import 'package:pokedex_app/pages/tela_tipo.dart';

void main(){
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      Geracao.routeName : (context) => Geracao(),
      Habitat.routeName : (context) => Habitat(),
      Tipo.routeName : (context) => Tipo(),
      NomeId.routeName : (context) => NomeId(),
      Lista.routeName : (context) => Lista()      
    },
    debugShowCheckedModeBanner: false,
    title: "Pokedex",
    home: Home(),
  ));
}