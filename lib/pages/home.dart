import 'package:flutter/material.dart';
import 'package:pokedex_app/pages/tela_geracao.dart';
import 'package:pokedex_app/pages/tela_habitat.dart';
import 'package:pokedex_app/pages/tela_id.dart';
import 'package:pokedex_app/pages/tela_tipo.dart';

var colors = {
  'yellow' : Color.fromARGB(255, 255, 203, 0),
  'blue' : Color.fromARGB(255, 46, 108, 181)
};

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _option;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors['blue'],
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'images/pokeball.png',
          ),
        ),
        title: Text(
          'Pokédex',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('images/logo.png'),

            DropdownButton(
              value: _option,
              hint: Text("Escolha um filtro"),
              items: const [
                DropdownMenuItem(value: "Geração", child: Text("Geração")),
                DropdownMenuItem(value: "Habitat", child: Text("Habitat")),
                DropdownMenuItem(value: "Tipo", child: Text("Tipo")),
                DropdownMenuItem(value: "Nome/Id", child: Text("Nome/Id")),
              ],
              onChanged: (String? selectedOption){
                if (selectedOption is String){
                  setState(() {
                    _option = selectedOption;
                  });
                }
              },

            ),
            ElevatedButton(
              onPressed: (_option != null) ? () {
                switch (_option){
                  case "Geração":
                    Navigator.pushNamed(context, 
                    Geracao.routeName);
                    break;
                  case "Habitat":
                    Navigator.pushNamed(context, 
                    Habitat.routeName);
                    break;
                  case "Tipo":
                    Navigator.pushNamed(context, 
                    Tipo.routeName);
                    break;
                  case "Nome/Id":
                    Navigator.pushNamed(context, 
                    NomeId.routeName);
                    break;
                }
              } : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.blueGrey,
                disabledForegroundColor: Colors.white,
                backgroundColor: colors['blue'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                foregroundColor: Colors.white

              ),
              child: Text(
                'Selecionar Filtro',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            )
          ],
        ),
      ),
    );
  }
}